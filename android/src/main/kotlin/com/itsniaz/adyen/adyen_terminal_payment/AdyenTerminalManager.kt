package com.itsniaz.adyen.adyen_terminal_payment

import com.itsniaz.adyen.adyen_terminal_payment.data.AdyenTerminalConfig

object AdyenTerminalManager {

    private  lateinit var terminalConfig: AdyenTerminalConfig

    fun init(adyenTerminalConfig: AdyenTerminalConfig){
        this.terminalConfig = adyenTerminalConfig
    }

    fun authorizePayment(double: Double?, captureType: String?){

    }

}