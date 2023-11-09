package com.cheqplease.adyen_terminal


object Utils {

    fun decodeUrlEncodedString(encodedString: String): String {
        return java.net.URLDecoder.decode(encodedString, "UTF-8")
    }

    fun getResponseDataValue(inputString: String): String {
        val regex = Regex("""responseData=\{"signature":(\{.*\})\}""")
        val matchResult = regex.find(inputString)
        val responseData = matchResult?.groups?.get(1)?.value
        return responseData ?: "";
    }



}