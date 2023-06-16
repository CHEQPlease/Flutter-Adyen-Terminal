package com.cheqplease.adyen_terminal

import android.content.Context
import androidx.annotation.NonNull
import com.cheqplease.adyen_terminal.data.AdyenTerminalConfig
import com.cheqplease.adyen_terminal.data.TransactionFailureHandler
import com.cheqplease.adyen_terminal.data.TransactionSuccessHandler
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.math.BigDecimal


class AdyenTerminalPaymentPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var applicationContext: Context
    private lateinit var flutterAssets: FlutterAssets
    private lateinit var channel: MethodChannel

    companion object {
        lateinit var adyenTerminalConfig: AdyenTerminalConfig
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger,flutterPluginBinding.flutterAssets)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger,flutterAssets: FlutterAssets) {
        this.applicationContext = applicationContext
        this.flutterAssets = flutterAssets
        channel = MethodChannel(messenger, "com.cheqplease.adyen_terminal/channel")
        channel.setMethodCallHandler(this)
    }

    @OptIn(DelicateCoroutinesApi::class)
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "init" -> {
                val certPath = call.argument<String>("certPath")?: throw IllegalArgumentException("Cert path value not found")
                adyenTerminalConfig = AdyenTerminalConfig(
                    endpoint = call.argument<String>("endpoint") ?: throw IllegalArgumentException("Endpoint value not found"),
                    backendApiKey = call.argument<String>("apiKey"),
                    terminalModelNo = call.argument<String>("terminalModelNo") ?: throw IllegalArgumentException("Terminal model number value not found"),
                    terminalSerialNo = call.argument<String>("terminalSerialNo") ?: throw IllegalArgumentException("Terminal serial number value not found"),
                    terminalId = call.argument<String>("terminalId") ?: throw IllegalArgumentException("Terminal ID value not found"),
                    merchantId = call.argument<String>("merchantId"),
                    environment = call.argument<String>("environment") ?: throw IllegalArgumentException("Environment value not found"),
                    keyId = call.argument<String>("keyId") ?: throw IllegalArgumentException("Key ID value not found"),
                    keyPassphrase = call.argument<String>("keyPassphrase") ?: throw IllegalArgumentException("Key passphrase value not found"),
                    merchantName = call.argument<String>("merchantName") ?: throw IllegalArgumentException("Merchant name value not found"),
                    keyVersion = call.argument<String>("keyVersion") ?: throw IllegalArgumentException("Key version value not found"),
                    certPath = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(certPath),
                    connectionTimeoutMillis = call.argument<Int>("connectionTimeoutMillis") ?: throw IllegalArgumentException("Connection timeout value not found"),
                    readTimeoutMillis = call.argument<Int>("readTimeoutMillis") ?: throw IllegalArgumentException("Read timeout value not found"),
                    showLogs = call.argument<Boolean>("showLogs") ?: false
                )

                AdyenTerminalManager.init(adyenTerminalConfig,applicationContext)
            }
            "authorize_transaction" -> {

                val amount = call.argument<Double>("amount")
                val captureType = call.argument<String>("captureType")
                val transactionId = call.argument<String>("transactionId")
                val currency = call.argument<String>("currency")
                val reqAmount = call.argument<Double>("amount")

                if (amount != null && captureType!=null && transactionId!=null && currency!=null && reqAmount!=null) {
                    GlobalScope.launch(Dispatchers.IO) {
                        try {
                            AdyenTerminalManager.authorizeTransaction(
                                transactionId = transactionId,
                                captureType = captureType,
                                currency = currency,
                                requestAmount = BigDecimal.valueOf(reqAmount),
                                terminalId = adyenTerminalConfig.terminalId,
                                paymentSuccessHandler = object :
                                    TransactionSuccessHandler<String?> {
                                    override fun onSuccess(response: String?) {
                                        result.success(response)
                                    }
                                },
                                paymentFailureHandler = object : TransactionFailureHandler<Int,String> {
                                    override fun onFailure(errorCode : Int?, response: String?) {
                                        result.error("ERROR","TXN FAILED",response)
                                    }
                                }

                            )
                        } catch (e: Exception) {
                            result.error("ERROR","TXN FAILED",e.message)
                            println(e.stackTraceToString())
                        }
                    }
                }
            }
            "cancel_transaction" -> {

                val txnId = call.argument<String>("transactionId")
                val cancelTxnId = call.argument<String>("cancelTxnId")
                if (txnId!=null && cancelTxnId!=null) {
                    GlobalScope.launch(Dispatchers.IO) {
                        try {
                            AdyenTerminalManager.cancelTransaction(
                                transactionId = txnId,
                                txnIdToCancel = cancelTxnId,
                                terminalId = adyenTerminalConfig.terminalId
                            )
                        } catch (e: Exception) {
                            println(e.stackTraceToString())
                        }
                    }
                }
            }
            "print_receipt" -> {

                val transactionId = call.argument<String>("transactionId")!!
                val receiptDTOJSON = call.argument<String>("receiptDTOJSON")!!

                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        AdyenTerminalManager.printReceipt(
                            context = applicationContext,
                            transactionId = transactionId,
                            receiptDTOJSON = receiptDTOJSON,
                            successHandler = object : TransactionSuccessHandler<Void> {
                                override fun onSuccess(response: Void?) {
                                    result.success(true)
                                }
                            },
                            failureHandler = object : TransactionFailureHandler<Int,String> {
                                override fun onFailure(errorCode: Int?, response: String?) {
                                    result.error("PRINT_ERROR","Unable to print",response)
                                }
                            }
                        )
                    } catch (e: Exception) {
                        result.error("PRINT_ERROR","Unable to print",e.message)
                    }
                }
            }

            "scan_barcode" ->{
                val transactionId = call.argument<String>("transactionId")!!
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        AdyenTerminalManager.scanBarcode(transactionId)
                    } catch (e: Exception) {
                        result.error("PRINT_ERROR","Unable to print",e.message)
                    }
                }
            }

            "get_terminal_info" -> {
                val transactionId = call.argument<String>("transactionId")!!
                val terminalIP = call.argument<String>("terminalIP")!!
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        AdyenTerminalManager.getTerminalInfo(
                            txnId = transactionId,
                            terminalIP = terminalIP,
                            successHandler = object : TransactionSuccessHandler<String> {
                                override fun onSuccess(response: String?) {
                                    result.success(response)
                                }
                            },
                            failureHandler = object : TransactionFailureHandler<Int,String> {
                                override fun onFailure(errorCode: Int?, response: String?) {
                                    result.error("ERROR", "Unable to get device info", null)
                                }
                            }
                        )
                    } catch (e: Exception){
                        result.error("ERROR", "Unable to get device info", null)
                    }
                }

            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
