package com.itsniaz.adyen.adyen_terminal_payment.receipt

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.itsniaz.adyen.adyen_terminal_payment.SingletonHolder
import com.itsniaz.adyen.adyen_terminal_payment.databinding.LayoutCustomerKioskReceiptBinding
import com.itsniaz.adyen.adyen_terminal_payment.databinding.LayoutCustomerPosReceiptBinding
import com.itsniaz.adyen.adyen_terminal_payment.databinding.LayoutKitchenReceiptBinding
import com.itsniaz.adyen.adyen_terminal_payment.databinding.LayoutMerchantReceiptBinding
import com.itsniaz.adyen.adyen_terminal_payment.receipt.adapter.BreakdownListAdapter
import com.itsniaz.adyen.adyen_terminal_payment.receipt.adapter.DishListAdapterCustomer
import com.itsniaz.adyen.adyen_terminal_payment.receipt.adapter.KitchenDishListAdapter
import com.itsniaz.adyen.adyen_terminal_payment.receipt.data.RECEIPT_TYPE
import com.itsniaz.adyen.adyen_terminal_payment.receipt.data.ReceiptDTO

class ReceiptBuilder private constructor(context: Context) {

    private var context : Context = context
    companion object : SingletonHolder<ReceiptBuilder, Context>(::ReceiptBuilder)

    fun buildReceipt(receiptDTO: ReceiptDTO): Bitmap? {

        when(receiptDTO.receiptType?.uppercase()){
            RECEIPT_TYPE.CUSTOMER.name ->{
                return buildCustomerPOSReceipt(receiptDTO)
            }
            RECEIPT_TYPE.MERCHANT.name -> {
                return buildMerchantReceipt(receiptDTO)

            }
            RECEIPT_TYPE.KIOSK.name ->{
                return buildCustomerKioskReceipt(receiptDTO)

            }
            RECEIPT_TYPE.KITCHEN.name ->{
                return buildKitchenReceipt(receiptDTO)
            }
        }

        return  null

    }

    private fun buildCustomerPOSReceipt(receiptDTO: ReceiptDTO) : Bitmap {

        val binding = LayoutCustomerPosReceiptBinding.inflate(LayoutInflater.from(context))
        val customerReceipt = binding.layoutCustomerReceiptPos

        /* TODO : Move to string resource to support localization in future*/

        binding.tvBrandName.text = receiptDTO.brandName
        binding.tvOrderNo.text = "ORDER #: ${receiptDTO.orderNo}"
        binding.tvTotalItems.text = "TOTAL ITEMS - ${receiptDTO.totalItems}" /* TODO : Move to plural type string resource*/
        binding.tvPlacedAt.text = receiptDTO.timeOfOrder
        binding.rvDishes.adapter = DishListAdapterCustomer(receiptDTO.items)
        binding.rvDishes.layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
        binding.rvBreakdown.adapter = BreakdownListAdapter(receiptDTO.breakdown)
        binding.rvBreakdown.layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)



        customerReceipt.measure( View.MeasureSpec.makeMeasureSpec(700, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED))
        customerReceipt.layout(0, 0, customerReceipt.measuredWidth, customerReceipt.measuredHeight)

        return getBitmapFromView(customerReceipt)

    }

    private fun buildCustomerKioskReceipt(receiptDTO: ReceiptDTO) : Bitmap {
        val binding = LayoutCustomerKioskReceiptBinding.inflate(LayoutInflater.from(context))
        val customerReceiptKiosk = binding.layoutCustomerReceiptKiosk

        /* TODO : Move to string resource to support localization in future */

        binding.tvBrandName.text = receiptDTO.brandName
        binding.tvOrderNo.text = "ORDER #: ${receiptDTO.orderNo}"
        binding.tvTotalItems.text = "TOTAL ITEMS - ${receiptDTO.totalItems}" /* TODO : Move to plural type string resource*/
        binding.tvPlacedAt.text = receiptDTO.timeOfOrder
        binding.rvDishes.adapter = DishListAdapterCustomer(receiptDTO.items)
        binding.rvDishes.layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
        binding.rvBreakdown.adapter = BreakdownListAdapter(receiptDTO.breakdown)
        binding.rvBreakdown.layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
        binding.tvOrderType.text = receiptDTO.orderType
        customerReceiptKiosk.measure( View.MeasureSpec.makeMeasureSpec(700, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED))
        customerReceiptKiosk.layout(0, 0, customerReceiptKiosk.measuredWidth, customerReceiptKiosk.measuredHeight)

        return getBitmapFromView(customerReceiptKiosk)
    }

    private fun buildMerchantReceipt(receiptDTO: ReceiptDTO) : Bitmap {
        val binding = LayoutMerchantReceiptBinding.inflate(LayoutInflater.from(context))
        val customerReceiptKiosk = binding.layoutMerchantReceiptBinding

        /* TODO : Move to string resource to support localization in future */

        binding.tvBrandName.text = receiptDTO.brandName
        binding.tvOrderNo.text = "ORDER #: ${receiptDTO.orderNo}"
        if (receiptDTO.tableNo.isNullOrEmpty()) {
            binding.tvTableNo.visibility = View.GONE
            binding.tvOrderNo.gravity = Gravity.CENTER
        }else{
            binding.tvTableNo.text = receiptDTO.tableNo
            binding.tvOrderNo.gravity = Gravity.END
        }
        binding.tvPlacedAt.text = receiptDTO.timeOfOrder
        binding.rvBreakdown.adapter = BreakdownListAdapter(receiptDTO.breakdown)
        binding.rvBreakdown.layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
        customerReceiptKiosk.measure( View.MeasureSpec.makeMeasureSpec(700, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED))
        customerReceiptKiosk.layout(0, 0, customerReceiptKiosk.measuredWidth, customerReceiptKiosk.measuredHeight)

        return getBitmapFromView(customerReceiptKiosk)

    }

    private fun buildKitchenReceipt(receiptDTO: ReceiptDTO) : Bitmap? {
        val binding = LayoutKitchenReceiptBinding.inflate(LayoutInflater.from(context))
        val customerReceiptKiosk = binding.layoutKitchenReceipt

        /* TODO : Move to string resource to support localization in future */

        binding.tvOrderNo.text = "Order #: ${receiptDTO.orderNo
        }"
        binding.tvPlacedAt.text = receiptDTO.timeOfOrder
        binding.tvOrderSubtitle.text = receiptDTO.orderSubtitle
        binding.rvDishes.adapter = KitchenDishListAdapter(receiptDTO.items)
        binding.rvDishes.layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
        if(receiptDTO.orderSubtitle.isNullOrEmpty()){
            binding.tvOrderSubtitle.visibility = View.GONE
        }
        customerReceiptKiosk.measure( View.MeasureSpec.makeMeasureSpec(700, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED))
        customerReceiptKiosk.layout(0, 0, customerReceiptKiosk.measuredWidth, customerReceiptKiosk.measuredHeight)

        return getBitmapFromView(customerReceiptKiosk)

    }

    private  fun getBitmapFromView(view: View): Bitmap {
        val bitmap = Bitmap.createBitmap(view.width, view.height, Bitmap.Config.RGB_565)
        val canvas = Canvas(bitmap)
        view.draw(canvas)
        return bitmap
    }

}