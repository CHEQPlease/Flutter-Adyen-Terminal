package com.cheqplease.adyen_terminal.data

interface TransactionSuccessHandler<T> {
    fun onSuccess(response : T?)
}

interface TransactionFailureHandler<EC, T>{
    fun onFailure(errorCode: EC?, response: T?)
}
