package com.itsniaz.adyen.adyen_terminal_payment.receipt.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.itsniaz.adyen.adyen_terminal_payment.databinding.LayoutMetaInfoBinding
import com.itsniaz.adyen.adyen_terminal_payment.databinding.LayoutPurchasedItemsBinding
import com.itsniaz.adyen.adyen_terminal_payment.receipt.data.Breakdown

class BreakdownListAdapter(private val breakdowns: List<Breakdown>) : RecyclerView.Adapter<BreakdownListAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding : LayoutMetaInfoBinding = LayoutMetaInfoBinding.inflate(
            LayoutInflater.from(parent.context),parent,false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        val breakdown = breakdowns[position]
        holder.binding.tvBreakdownKeyName.text = breakdown.key
        holder.binding.tvBreakdownKeyValue.text = breakdown.value
    }

    override fun getItemCount(): Int {
        return breakdowns.size
    }

    class ViewHolder(var binding: LayoutMetaInfoBinding) : RecyclerView.ViewHolder(binding.root)

}