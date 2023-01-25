package com.itsniaz.adyen.adyen_terminal_payment

interface TransactionSuccessHandler<T> {
    fun onSuccess(response : T?)
}

interface TransactionFailureHandler<T>{
    fun onFailure(response: T?)
}
