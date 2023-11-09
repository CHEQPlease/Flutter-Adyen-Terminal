package com.cheqplease.adyen_terminal.data


interface TransactionSuccessHandler<T> {
    fun onSuccess(response : T?)
}

interface TransactionFailureHandler<EC, T>{
    fun onFailure(errorCode: ErrorCode, response: T?)
}


interface SignatureHandler{
    fun onSignatureReceived(signature: String)
    fun onSignatureRejected()
}