package com.itsniaz.adyen.adyen_terminal_payment.receipt

import android.content.Context
import android.graphics.Bitmap
import com.itsniaz.adyen.adyen_terminal_payment.SingletonHolder
import com.itsniaz.adyen.adyen_terminal_payment.receipt.data.ReceiptDTO

class ReceiptBuilder constructor(context: Context) {


    companion object : SingletonHolder<ReceiptBuilder, Context>(::ReceiptBuilder)

    fun buildReceipt(receiptDTO: ReceiptDTO){

        val receiptType = receiptDTO.receiptType?.uppercase()

        when(receiptType){
            "CUSTOMER" ->{

            }
            ""
        }

    }

    private fun buildCustomerPOSReceipt(receiptDTO: ReceiptDTO) : Bitmap {

    }

}