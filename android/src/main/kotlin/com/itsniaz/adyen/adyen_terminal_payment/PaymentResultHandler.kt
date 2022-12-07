package com.itsniaz.adyen.adyen_terminal_payment

interface PaymentSuccessHandler<T> {

    fun onSuccess(response : T)

}

interface PaymentFailureHandler<T>{
    fun onFailure(response: T)
}
