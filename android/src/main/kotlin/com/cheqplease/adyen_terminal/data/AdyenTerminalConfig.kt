package com.cheqplease.adyen_terminal.data

data class AdyenTerminalConfig(
    val endpoint: String,
    val backendApiKey: String?,
    val terminalModelNo: String,
    val terminalSerialNo: String,
    val terminalId: String,
    val environment: String,
    val keyId: String,
    val keyPassphrase: String,
    val keyVersion: String,
    val merchantId: String?,
    val merchantName: String,
    val certPath: String,
    val connectionTimeoutMillis: Int,
    val readTimeoutMillis: Int,
    val showLogs: Boolean = false
)
