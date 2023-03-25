package com.cheqplease.adyen_terminal.dantsu

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Build
import android.os.Parcelable
import com.cheqplease.adyen_terminal.data.AdyenTerminalConfig
import com.dantsu.escposprinter.connection.usb.UsbConnection
import com.dantsu.escposprinter.connection.usb.UsbPrintersConnections
import java.lang.ref.WeakReference

object DantsuPrintManager {

    private lateinit var context: WeakReference<Context>

    fun init(context: Context) {
        DantsuPrintManager.context = WeakReference<Context>(context)
    }

    private const val ACTION_USB_PERMISSION = "com.android.example.USB_PERMISSION"

    fun printUsb() {
        val usbConnection: UsbConnection? = UsbPrintersConnections.selectFirstConnected(context.get())
        val usbManager = context.get()?.getSystemService(Context.USB_SERVICE) as UsbManager?
        if (usbConnection != null && usbManager != null) {
            val permissionIntent = PendingIntent.getBroadcast(
                context.get(),
                0,
                Intent(ACTION_USB_PERMISSION),
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_MUTABLE else 0
            )
            val filter = IntentFilter(ACTION_USB_PERMISSION)
            context.get()?.registerReceiver(object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent) {
                    val action = intent.action
                    if (ACTION_USB_PERMISSION == action) {
                        synchronized(this) {
                            val usbManager = context?.getSystemService(Context.USB_SERVICE) as UsbManager?
                            val usbDevice =
                                intent.getParcelableExtra<Parcelable>(UsbManager.EXTRA_DEVICE) as UsbDevice?
                            if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                                if (usbManager != null && usbDevice != null) {


                                }
                            }
                        }
                    }
                }
            }, filter)
            usbManager.requestPermission(usbConnection.device, permissionIntent)
        }
    }

}