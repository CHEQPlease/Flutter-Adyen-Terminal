package com.itsniaz.adyen.adyen_terminal_payment.data

data class AdyenTerminalConfig(
    val endpoint: String,
    val terminalModelNo : String,
    val terminalSerialNo : String,
    val terminalId: String,
    val environment: String,
    val key_id: String,
    val key_passphrase: String,
    val key_version: String,
    val merchantId: String?,
    val merchant_name: String,
    val certPath : String
)