package com.cheqplease.adyen_terminal


import android.content.Context
import androidx.annotation.NonNull
import com.cheqplease.adyen_terminal.data.AdyenTerminalConfig
import com.cheqplease.adyen_terminal.data.ErrorCode
import com.cheqplease.adyen_terminal.data.SignatureHandler
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
import java.io.PrintWriter
import java.io.StringWriter
import java.math.BigDecimal


class AdyenTerminalPaymentPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var applicationContext: Context
    private lateinit var flutterAssets: FlutterAssets
    private lateinit var channel: MethodChannel

    companion object {
        lateinit var adyenTerminalConfig: AdyenTerminalConfig
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        onAttachedToEngine(
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger,
            flutterPluginBinding.flutterAssets
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun onAttachedToEngine(
        applicationContext: Context,
        messenger: BinaryMessenger,
        flutterAssets: FlutterAssets
    ) {
        this.applicationContext = applicationContext
        this.flutterAssets = flutterAssets
        channel = MethodChannel(messenger, "com.cheqplease.adyen_terminal/channel")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> handleInit(call, result)
            "authorize_transaction" -> handleAuthorizeTransaction(call, result)
            "cancel_transaction" -> handleCancelTransaction(call, result)
            "print_receipt" -> handlePrintReceipt(call, result)
            "scan_barcode" -> handleScanBarcode(call, result)
            "get_terminal_info" -> handleGetTerminalInfo(call, result)
            "get_signature" -> handleSignature(call, result)
            "tokenize_card" -> handleCardTokenization(call, result)
            else -> result.notImplemented()
        }
    }

    private fun handleInit(call: MethodCall, result: Result) {
        val certPath = getArgumentOrThrow<String>(call, "certPath")
        adyenTerminalConfig = AdyenTerminalConfig(
            endpoint = getArgumentOrThrow(call, "endpoint"),
            backendApiKey = call.argument<String>("backendApiKey"),
            terminalModelNo = getArgumentOrThrow(call, "terminalModelNo"),
            terminalSerialNo = getArgumentOrThrow(call, "terminalSerialNo"),
            terminalId = getArgumentOrThrow(call, "terminalId"),
            merchantId = call.argument<String>("merchantId"),
            environment = getArgumentOrThrow(call, "environment"),
            keyId = getArgumentOrThrow(call, "keyId"),
            keyPassphrase = getArgumentOrThrow(call, "keyPassphrase"),
            merchantName = getArgumentOrThrow(call, "merchantName"),
            keyVersion = getArgumentOrThrow(call, "keyVersion"),
            certPath = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(certPath),
            connectionTimeoutMillis = getArgumentOrThrow(call, "connectionTimeoutMillis"),
            readTimeoutMillis = getArgumentOrThrow(call, "readTimeoutMillis"),
            showLogs = getArgumentOrThrow(call, "showLogs", false)
        )

        AdyenTerminalManager.init(adyenTerminalConfig, applicationContext)
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun handleAuthorizeTransaction(call: MethodCall, result: Result) {
        val amount: Double = getArgumentOrThrow(call, "amount")
        val captureType: String = getArgumentOrThrow(call, "captureType")
        val transactionId: String = getArgumentOrThrow(call, "transactionId")
        val currency: String = getArgumentOrThrow(call, "currency")
        val additionalData: HashMap<String,Any> = getArgumentOrThrow(call, "additionalData", defaultValue = HashMap())
        val forcedEntryModes: List<String> = getArgumentOrThrow(call, "forcedEntryModes", defaultValue = emptyList())

        GlobalScope.launch(Dispatchers.IO) {
            try {
                AdyenTerminalManager.authorizeTransaction(
                    transactionId = transactionId,
                    captureType = captureType,
                    currency = currency,
                    requestAmount = BigDecimal.valueOf(amount),
                    terminalId = adyenTerminalConfig.terminalId,
                    paymentSuccessHandler = object :
                        TransactionSuccessHandler<String?> {
                        override fun onSuccess(response: String?) {
                            result.success(response)
                        }
                    },
                    additionalData = additionalData,
                    forcedEntryModes = forcedEntryModes,
                    paymentFailureHandler = object : TransactionFailureHandler<Int, String> {
                        override fun onFailure(errorCode: ErrorCode, response: String?) {
                            result.error(errorCode.name, "Transaction Failed", response)
                        }
                    }
                )
            } catch (e: Exception) {
                val stackTrace = StringWriter().apply {
                    e.printStackTrace(PrintWriter(this))
                }.toString()
                result.error(ErrorCode.UNABLE_TO_PROCESS_RESULT.toString(), e.message, stackTrace)
            }
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun handleCardTokenization(call: MethodCall, result: Result){

        val transactionId: String = getArgumentOrThrow(call, "transactionId")
        val amount: Double = getArgumentOrThrow(call, "amount")
        val currency: String = getArgumentOrThrow(call, "currency")
        val shopperEmail: String = getArgumentOrThrow(call, "shopperEmail")
        val shopperReference: String = getArgumentOrThrow(call, "shopperReference")


        GlobalScope.launch(Dispatchers.IO) {
            try {
                AdyenTerminalManager.tokenizeCard(
                    transactionId = transactionId,
                    requestedAmount = amount,
                    currency = currency,
                    shopperEmail = shopperEmail,
                    shopperReference = shopperReference,
                    successHandler = object :
                        TransactionSuccessHandler<String> {
                        override fun onSuccess(response: String?) {
                            result.success(response)
                        }
                    },
                    failureHandler = object : TransactionFailureHandler<Int, String> {
                        override fun onFailure(errorCode: ErrorCode, response: String?) {
                            result.error(errorCode.name, "Transaction Failed", response)
                        }
                    }
                )
            } catch (e: Exception) {
                val stackTrace = StringWriter().apply {
                    e.printStackTrace(PrintWriter(this))
                }.toString()
                result.error(ErrorCode.UNABLE_TO_PROCESS_RESULT.toString(), e.message, stackTrace)
            }
        }

    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun handleCancelTransaction(call: MethodCall, result: Result) {

        val txnId: String = getArgumentOrThrow(call, "transactionId")
        val cancelTxnId: String = getArgumentOrThrow(call, "cancelTxnId")
        GlobalScope.launch(Dispatchers.IO) {
            try {
                AdyenTerminalManager.cancelTransaction(
                    transactionId = txnId,
                    txnIdToCancel = cancelTxnId,
                    terminalId = adyenTerminalConfig.terminalId
                )
                result.success(true)
            } catch (e: Exception) {
                val stackTrace = StringWriter().apply {
                    e.printStackTrace(PrintWriter(this))
                }.toString()
                result.error(ErrorCode.UNABLE_TO_PROCESS_RESULT.toString(), e.message, stackTrace)
            }
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun handlePrintReceipt(call: MethodCall, result: Result) {
        val transactionId: String = getArgumentOrThrow(call, "transactionId")
        val receiptDTOJSON: String = getArgumentOrThrow(call, "receiptDTOJSON")
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
                    failureHandler = object : TransactionFailureHandler<Int, String> {
                        override fun onFailure(errorCode: ErrorCode, response: String?) {
                            result.error("PRINT_ERROR", "Unable to print", response)
                        }
                    }
                )
            } catch (e: Exception) {
                result.error("PRINT_ERROR", "Unable to print", e.message)
            }
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun handleScanBarcode(call: MethodCall, result: Result) {
        val transactionId : String = getArgumentOrThrow(call,"transactionId")!!
        GlobalScope.launch(Dispatchers.IO) {
            try {
                AdyenTerminalManager.scanBarcode(transactionId)
            } catch (e: Exception) {
                result.error("PRINT_ERROR", "Unable to print", e.message)
            }
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun handleGetTerminalInfo(call: MethodCall, result: Result) {
        val transactionId: String = getArgumentOrThrow(call, "transactionId")
        val terminalIP: String = getArgumentOrThrow(call, "terminalIP")
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
                    failureHandler = object : TransactionFailureHandler<Int, String> {
                        override fun onFailure(errorCode: ErrorCode, response: String?) {
                            result.error("ERROR", "Unable to get device info", null)
                        }
                    }
                )
            } catch (e: Exception) {
                result.error("ERROR", "Unable to get device info", null)
            }
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun handleSignature(call: MethodCall, result: Result) {
        val transactionId: String = getArgumentOrThrow(call, "transactionId")

        GlobalScope.launch(Dispatchers.IO) {
            try {
                AdyenTerminalManager.getSignature(transactionId, object : SignatureHandler {
                    override fun onSignatureReceived(signature: String) {
                        result.success(signature)
                    }

                    override fun onSignatureRejected() {
                        result.error("ERROR", "Signature Rejected", null)
                    }
                })
            } catch (e: Exception) {
                result.error("ERROR", "Signature Rejected", null)
            }
        }

    }


    private fun <T> getArgumentOrThrow(
        call: MethodCall,
        argumentName: String,
        defaultValue: T? = null
    ): T {
        return call.argument<T>(argumentName) ?: defaultValue
        ?: throw IllegalArgumentException("$argumentName value not found")
    }

}