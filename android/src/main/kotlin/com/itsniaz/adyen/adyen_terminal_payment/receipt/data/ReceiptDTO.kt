package com.itsniaz.adyen.adyen_terminal_payment.receipt.data

import com.google.gson.annotations.SerializedName

data class ReceiptDTO(
    @SerializedName("brandName")
    val brandName: String?,
    @SerializedName("breakdown")
    val breakdown: List<Breakdown> = listOf(),
    @SerializedName("items")
    val items: List<Item> = listOf(),
    @SerializedName("orderNo")
    val orderNo: String?,
    @SerializedName("orderType")
    val orderType: String?,
    @SerializedName("receiptType")
    val receiptType: String?,
    @SerializedName("tableNo")
    val tableNo: String?,
    @SerializedName("timeOfOrder")
    val timeOfOrder: String?,
    @SerializedName("totalItems")
    val totalItems: String?
)

data class Breakdown(
    @SerializedName("important")
    val important: Boolean?,
    @SerializedName("key")
    val key: String?,
    @SerializedName("value")
    val value: String?
)

data class Item(
    @SerializedName("description")
    val description: String?,
    @SerializedName("itemName")
    val itemName: String?,
    @SerializedName("price")
    val price: String?,
    @SerializedName("quantity")
    val quantity: String?,
    @SerializedName("strikethrough")
    val strikethrough: Boolean?
)

enum class RECEIPT_TYPE {
    CUSTOMER, MERCHANT, KITCHEN, KIOSK
}