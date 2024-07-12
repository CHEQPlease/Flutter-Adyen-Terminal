package com.cheqplease.adyen_terminal.data

enum class CommunicationMode(val value: String) {
    LOCAL("LOCAL"),
    CLOUD("CLOUD");

    companion object {
        @JvmStatic
        fun fromValue(value: String): CommunicationMode {
            return values().find { it.value.equals(value, ignoreCase = true) }
                ?: throw IllegalArgumentException("Unknown CommunicationMode: $value")
        }
    }
}