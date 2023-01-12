package com.itsniaz.adyen.adyen_terminal_payment.receipt.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.itsniaz.adyen.adyen_terminal_payment.databinding.LayoutPurchasedItemsBinding
import com.itsniaz.adyen.adyen_terminal_payment.receipt.data.Item

class DishListAdapterCustomer(private val dishes: List<Item>) : RecyclerView.Adapter<DishListAdapterCustomer.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding :  LayoutPurchasedItemsBinding = LayoutPurchasedItemsBinding.inflate(LayoutInflater.from(parent.context),parent,false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        val dish = dishes[position]

        holder.binding.tvItemName.text = "${dish.itemName}x" /* TODO : Move to string resource to support localization in future */
        holder.binding.tvItemDetails.text = dish.description
        holder.binding.tvPrice.text = "${dish.price}"
        holder.binding.tvQty.text = "${dish.quantity}"
    }

    override fun getItemCount(): Int {
        return dishes.size
    }

    class ViewHolder(var binding: LayoutPurchasedItemsBinding) : RecyclerView.ViewHolder(binding.root)

}