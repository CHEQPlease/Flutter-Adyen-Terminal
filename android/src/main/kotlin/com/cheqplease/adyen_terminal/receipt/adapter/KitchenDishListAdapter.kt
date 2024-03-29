package com.cheqplease.adyen_terminal.receipt.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cheqplease.adyen_terminal.databinding.LayoutKitchenItemInfoBinding
import com.cheqplease.adyen_terminal.receipt.data.Item
import com.cheqplease.adyen_terminal.receipt.showStrikeThrough

class KitchenDishListAdapter(private val dishes: List<Item>) : RecyclerView.Adapter<KitchenDishListAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding : LayoutKitchenItemInfoBinding = LayoutKitchenItemInfoBinding.inflate(LayoutInflater.from(parent.context),parent,false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        val dish = dishes[position]

        holder.binding.tvItemName.text = "${dish.itemName}" /* TODO : Move to string resource to support localization in future */
        holder.binding.tvItemDetails.text = dish.description
        holder.binding.tvQty.text = "x${dish.quantity}"

        if(dish.strikethrough){
            holder.binding.tvItemName.showStrikeThrough(true)
            holder.binding.tvItemDetails.showStrikeThrough(true)
            holder.binding.tvQty.showStrikeThrough(true)
        }

    }

    override fun getItemCount(): Int {
        return dishes.size
    }

    class ViewHolder(var binding: LayoutKitchenItemInfoBinding) : RecyclerView.ViewHolder(binding.root)

}