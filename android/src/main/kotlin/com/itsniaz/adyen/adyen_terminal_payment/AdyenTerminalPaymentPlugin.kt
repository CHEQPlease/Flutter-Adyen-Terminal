package com.itsniaz.adyen.adyen_terminal_payment

import android.content.Context
import androidx.annotation.NonNull
import com.itsniaz.adyen.adyen_terminal_payment.data.AdyenTerminalConfig

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AdyenTerminalPaymentPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var applicationContext: Context
    private lateinit var flutterAssets: FlutterAssets
    private lateinit var channel: MethodChannel
    private lateinit var flutterPluginBinding : FlutterPluginBinding

    companion object {
        lateinit var adyenTerminalConfig: AdyenTerminalConfig
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger,flutterPluginBinding.flutterAssets)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger,flutterAssets: FlutterAssets) {
        this.applicationContext = applicationContext
        this.flutterAssets = flutterAssets
        channel = MethodChannel(messenger, "com.itsniaz.adyenterminal/channel")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {


        if (call.method == "init") {
            adyenTerminalConfig = AdyenTerminalConfig(
                endpoint = call.argument<String>("endpoint")!!,
                merchantId = call.argument<String>("merchantId")!!,
                environment = call.argument<String>("environment")!!,
                key_id = call.argument<String>("key_id")!!,
                key_passphrase = call.argument<String>("key_passphrase")!!,
                merchant_name = call.argument<String>("merchant_name")!!,
                key_version = call.argument<String>("key_version")!!,
                certPath = "demo_cert.pem"
            )
            AdyenTerminalManager.init(adyenTerminalConfig)

        } else if (call.method == "authorize_payment") {
            val doubleAmount = call.argument<Double>("amount");
            val captureType = call.argument<String>("captureType")
            AdyenTerminalManager.authorizePayment(doubleAmount,captureType)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
