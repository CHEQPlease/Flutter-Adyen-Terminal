package com.cheqplease.adyen_terminal.receipt.adapter

import android.util.TypedValue
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.cheqplease.adyen_terminal.databinding.LayoutMetaInfoBinding
import com.cheqplease.adyen_terminal.receipt.data.Breakdown

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

        if(breakdown.important){
            holder.binding.tvBreakdownKeyName.setTextSize(TypedValue.COMPLEX_UNIT_MM,3.0f)
            holder.binding.tvBreakdownKeyValue.setTextSize(TypedValue.COMPLEX_UNIT_MM,3.0f)
        }
    }

    override fun getItemCount(): Int {
        return breakdowns.size
    }

    class ViewHolder(var binding: LayoutMetaInfoBinding) : RecyclerView.ViewHolder(binding.root)

}