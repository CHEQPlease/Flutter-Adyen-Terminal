package com.cheqplease.adyen_terminal

import android.content.Context
import android.graphics.Bitmap
import android.util.Base64
import android.util.Base64.encodeToString
import android.util.Log
import com.adyen.Client
import com.adyen.Config
import com.adyen.enums.Environment
import com.adyen.model.nexo.*
import com.adyen.model.posterminalmanagement.GetTerminalDetailsRequest
import com.adyen.model.posterminalmanagement.GetTerminalDetailsResponse
import com.adyen.model.terminal.SaleToAcquirerData
import com.adyen.model.terminal.TerminalAPIRequest
import com.adyen.model.terminal.security.SecurityKey
import com.adyen.service.PosTerminalManagement
import com.adyen.service.TerminalLocalAPI
import com.google.gson.Gson
import com.cheqplease.adyen_terminal.data.AdyenTerminalConfig
import com.cheqplease.adyen_terminal.receipt.ReceiptBuilder
import com.cheqplease.adyen_terminal.receipt.data.ReceiptDTO
import com.cheqplease.adyen_terminal_payment.TransactionFailureHandler
import com.cheqplease.adyen_terminal_payment.TransactionSuccessHandler
import org.json.JSONObject
import java.io.ByteArrayOutputStream
import java.io.InputStream
import java.lang.ref.WeakReference
import java.math.BigDecimal
import java.util.*
import javax.xml.datatype.DatatypeFactory


object AdyenTerminalManager {

    private lateinit var terminalConfig: AdyenTerminalConfig
    private lateinit var context: WeakReference<Context>

    fun init(adyenTerminalConfig: AdyenTerminalConfig, context: Context) {
        terminalConfig = adyenTerminalConfig
        AdyenTerminalManager.context = WeakReference<Context>(context)
    }

    fun authorizeTransaction(
        transactionId: String,
        terminalId: String,
        captureType: String,
        currency: String,
        requestAmount: BigDecimal,
        paymentSuccessHandler: TransactionSuccessHandler<String?>,
        paymentFailureHandler: TransactionFailureHandler<String>
    ) {

        val config: Config = getConfigurationData(terminalConfig)
        val terminalLocalAPIClient = Client(config)
        val terminalLocalAPI = TerminalLocalAPI(terminalLocalAPIClient)
        val terminalApiRequest = TerminalAPIRequest()

        terminalApiRequest.apply {
            saleToPOIRequest = buildSalePOIRequest(
                saleID = terminalId,
                transactionId = transactionId,
                poiid = "${terminalConfig.terminalModelNo}-${terminalConfig.terminalSerialNo}",
                messageCategory = MessageCategoryType.PAYMENT,
                currency = currency,
                requestAmount = requestAmount,
                captureType = captureType
            )
        }

        val securityKey: SecurityKey = getSecurityKey(
            keyIdentifier = terminalConfig.key_id,
            passphrase = terminalConfig.key_passphrase
        )

        Log.d("terminalApiRequest>>", "" + Gson().toJson(terminalApiRequest))
        try {
            val response = terminalLocalAPI.request(terminalApiRequest, securityKey)

            if (response != null) {
                Log.d("terminalApiResponse>>", "" + Gson().toJson(response))
                val resultJson = Gson().toJson(response)
                if ("success".equals(
                        response.saleToPOIResponse.paymentResponse.response.result.value(),
                        ignoreCase = true
                    )
                ) {
                    paymentSuccessHandler.onSuccess(resultJson)
                } else {
                    paymentFailureHandler.onFailure(resultJson)
                }
            }

        } catch (e: Exception) {
            if (e.message != null) {
                paymentFailureHandler.onFailure(e.message!!)
            } else {
                paymentFailureHandler.onFailure("Failed to process transaction")
            }
        }
    }

    fun cancelTransaction(terminalId: String, transactionId: String, txnIdToCancel: String) {

        val config: Config = getConfigurationData(terminalConfig)
        val terminalLocalAPIClient = Client(config)
        val terminalLocalAPI = TerminalLocalAPI(terminalLocalAPIClient)
        val terminalApiRequest = TerminalAPIRequest()

        val securityKey: SecurityKey = getSecurityKey(
            keyIdentifier = terminalConfig.key_id,
            passphrase = terminalConfig.key_passphrase
        )

        terminalApiRequest.apply {
            saleToPOIRequest = SaleToPOIRequest().apply {
                messageHeader = MessageHeader().apply {
                    protocolVersion = "3.0"
                    messageClass = MessageClassType.SERVICE
                    messageCategory = MessageCategoryType.ABORT
                    messageType = MessageType.REQUEST
                    saleID = terminalId
                    serviceID = transactionId
                    poiid = "${terminalConfig.terminalModelNo}-${terminalConfig.terminalSerialNo}"
                }
                abortRequest = AbortRequest().apply {
                    abortReason = "Shopper Cancelled Transaction"
                    messageReference = MessageReference().apply {
                        messageCategory = MessageCategoryType.PAYMENT
                        saleID = terminalId
                        serviceID = txnIdToCancel
                    }
                }
            }
        }

        Log.d("terminalApiRequest>>", "" + Gson().toJson(terminalApiRequest))
        val response = terminalLocalAPI.request(terminalApiRequest, securityKey)
        Log.d("terminalApiResponse>>", "" + Gson().toJson(response))
    }


    fun printReceipt(
        context: Context,
        transactionId: String,
        receiptDTOJSON: String,
        successHandler: TransactionSuccessHandler<Void>,
        failureHandler: TransactionFailureHandler<String>
    ) {

        val customerReceiptBitmap = ReceiptBuilder.getInstance(context).buildReceipt(receiptDTO = Gson().fromJson(receiptDTOJSON,
            ReceiptDTO::class.java))
        val encoded: ByteArray? = customerReceiptBitmap?.let { bitmapToByteArray(bitmap = it) }
        val imageBase64Encoded = encodeToString(encoded, Base64.DEFAULT)
        val printData = """<?xml version="1.0" encoding="UTF-8"?><img src="data:image/png;base64, $imageBase64Encoded"/>""".trimIndent()


        val config: Config = getConfigurationData(terminalConfig)
        val terminalLocalAPIClient = Client(config)
        val terminalLocalAPI = TerminalLocalAPI(terminalLocalAPIClient)
        val terminalApiRequest = TerminalAPIRequest()

        val saleToPOIRequest = SaleToPOIRequest().apply {
            messageHeader = MessageHeader().apply {
                protocolVersion = "3.0"
                messageClass = MessageClassType.DEVICE
                messageCategory = MessageCategoryType.PRINT
                messageType = MessageType.REQUEST
                serviceID = transactionId
                saleID = terminalConfig.terminalId
                poiid = "${terminalConfig.terminalModelNo}-${terminalConfig.terminalSerialNo}"
                printRequest = PrintRequest().apply {
                    printOutput = PrintOutput().apply {
                        documentQualifier = DocumentQualifierType.DOCUMENT
                        responseMode = ResponseModeType.PRINT_END
                        outputContent = OutputContent().apply {
                            outputFormat = OutputFormatType.XHTML
                            outputXHTML = printData.encodeToByteArray()
                        }
                    }
                }
            }
        }

        terminalApiRequest.saleToPOIRequest = saleToPOIRequest

        try {
            val response = terminalLocalAPI.request(
                terminalApiRequest, getSecurityKey(
                    keyIdentifier = terminalConfig.key_id,
                    passphrase = terminalConfig.key_passphrase
                )
            )
            if (response != null && "success".equals(response.saleToPOIResponse.printResponse.response.result.name, ignoreCase = true)) {
                successHandler.onSuccess(null)
            } else {
                val errorMsg =
                    response.saleToPOIResponse.printResponse.response.additionalResponse
                failureHandler.onFailure(errorMsg)
            }
        } catch (e: Exception) {
            if (e.message != null) {
                failureHandler.onFailure("Printing Failed ${e.message!!}")
            } else {
                failureHandler.onFailure("Printing Failed")
            }
        }
    }


    fun getTerminalInfo(terminalIP: String, txnId: String, successHandler: TransactionSuccessHandler<String>, failureHandler: TransactionFailureHandler<String>){

        val config: Config = getConfigurationData(terminalConfig)
        config.apply {
            terminalApiLocalEndpoint = terminalIP
        }
        val terminalLocalAPIClient = Client(config)
        val terminalLocalAPI = TerminalLocalAPI(terminalLocalAPIClient)
        val terminalApiRequest = TerminalAPIRequest()

        val securityKey: SecurityKey = getSecurityKey(
            keyIdentifier = terminalConfig.key_id,
            passphrase = terminalConfig.key_passphrase
        )

        terminalApiRequest.apply {
            saleToPOIRequest = SaleToPOIRequest().apply {
                messageHeader = MessageHeader().apply {
                    protocolVersion = "3.0"
                    messageClass = MessageClassType.SERVICE
                    messageCategory = MessageCategoryType.DIAGNOSIS
                    messageType = MessageType.REQUEST
                    saleID = terminalConfig.terminalId
                    serviceID = txnId
                    poiid = "${terminalConfig.terminalModelNo}-${terminalConfig.terminalSerialNo}"
                }
                diagnosisRequest = DiagnosisRequest().apply {
                    isHostDiagnosisFlag = true
                }
            }
        }

        try {
            Log.d("terminalApiRequest>>", "" + Gson().toJson(terminalApiRequest))
            // Terminal poiid retrieval successful
            val response = terminalLocalAPI.request(terminalApiRequest, securityKey)
            val resultJSONString = Gson().toJson(response)
            val terminalDetailsJSON = JSONObject()
            val saleToPoiJsonObject = JSONObject(resultJSONString)
            terminalDetailsJSON.put("SaleToPOIResponse",saleToPoiJsonObject)

            //Get Verbose TerminalInfo from Web Mgmt API
            try {
                val terminalDetails = getTerminalDetails(response.saleToPOIResponse.messageHeader.poiid)
                val webApiResponseJSON = Gson().toJson(terminalDetails)
                val webApiResponseJSONObject = JSONObject(webApiResponseJSON)
                terminalDetailsJSON.put("WebAPIResponse",webApiResponseJSONObject)
                Log.d("terminalMgmtAPIResponse", " : $terminalDetails")
                successHandler.onSuccess(terminalDetailsJSON.toString())
            } catch (e: Exception) {
                Log.d("terminalMgmtAPIResponse", " : Failed to get WebApiResponse")
                successHandler.onSuccess(resultJSONString)
            }
        } catch (e: Exception) {
            Log.d("terminalMgmtAPIResponse", " : Error occurred retrieving terminal info.")
            if(BuildConfig.DEBUG){
                e.printStackTrace()
            }
            failureHandler.onFailure(null)
        }

    }


    private fun getTerminalDetails(poiid: String): GetTerminalDetailsResponse {
        val config: Config = getConfigurationDataForMgmtAPI(terminalConfig)
        val terminalMgmtClient = Client(config)
        val terminalMgmtAPI = PosTerminalManagement(terminalMgmtClient)

        val getTerminalDetailsRequest: GetTerminalDetailsRequest = GetTerminalDetailsRequest().apply {
            terminal = poiid
        }

        val response = terminalMgmtAPI.getTerminalDetails(getTerminalDetailsRequest)

        return response
    }


    fun scanBarcode(transactionId: String){

        val jsonReq = """{
            "Session": {
                "Id": "$transactionId",
                "Type": "Once"
            },
            "Operation": [
                {
                    "Type": "ScanBarcode",
                    "TimeoutMs": 5000
                }
            ]
        }
        """

       val jsonBase64 =  encodeToString(jsonReq.toByteArray(), Base64.DEFAULT)

        val config: Config = getConfigurationData(terminalConfig)
        val terminalLocalAPIClient = Client(config)
        val terminalLocalAPI = TerminalLocalAPI(terminalLocalAPIClient)
        val terminalApiRequest = TerminalAPIRequest()

        val saleToPOIRequest = SaleToPOIRequest().apply {
            messageHeader = MessageHeader().apply {

                protocolVersion = "3.0"
                messageClass = MessageClassType.SERVICE
                messageCategory = MessageCategoryType.ADMIN
                messageType = MessageType.REQUEST
                serviceID = transactionId
                saleID = terminalConfig.terminalId
                poiid = "${terminalConfig.terminalModelNo}-${terminalConfig.terminalSerialNo}"

                adminRequest = AdminRequest().apply {
                    serviceIdentification = jsonBase64
                }

            }
        }

        terminalApiRequest.saleToPOIRequest = saleToPOIRequest

        try {

            val response = terminalLocalAPI.request(
                terminalApiRequest, getSecurityKey(
                    keyIdentifier = terminalConfig.key_id,
                    passphrase = terminalConfig.key_passphrase
                )
            )
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }



    private fun buildSalePOIRequest(
        saleID: String,
        transactionId: String,
        messageCategory: MessageCategoryType,
        poiid: String,
        currency: String,
        requestAmount: BigDecimal,
        captureType: String
    ): SaleToPOIRequest {

        return SaleToPOIRequest().apply {
            messageHeader = buildMessageHeader(
                saleID = saleID,
                serviceID = transactionId,
                messageCategory = messageCategory,
                poiid = poiid
            )
            paymentRequest = buildPaymentRequest(
                currency = currency,
                requestAmount = requestAmount,
                transactionId = transactionId,
                captureType = captureType
            )
        }

    }

    private fun buildPaymentRequest(
        currency: String,
        requestAmount: BigDecimal,
        transactionId: String,
        captureType: String
    ): PaymentRequest {
        return PaymentRequest().apply {
            saleData = buildSaleData(transactionId = transactionId, captureType = captureType)
            paymentTransaction = buildPaymentTransaction(
                currency = currency,
                requestAmount = requestAmount
            )
        }
    }

    private fun buildPaymentTransaction(
        currency: String,
        requestAmount: BigDecimal
    ): PaymentTransaction {
        return PaymentTransaction().apply {
            amountsReq = AmountsReq().apply {
                this.currency = currency
                this.requestedAmount = requestAmount
            }
        }
    }

    private fun buildSaleData(transactionId: String, captureType: String): SaleData {

        val authType = if ("immediate".equals(
                captureType,
                ignoreCase = true
            )
        ) mapOf("authorisationType" to "FinalAuth") else mapOf("authorisationType" to "PreAuth")

        return SaleData().apply {
            saleTransactionID = TransactionIdentification().apply {
                transactionID = transactionId
                timeStamp = DatatypeFactory.newInstance()
                    .newXMLGregorianCalendar(GregorianCalendar(TimeZone.getTimeZone("GMT+6")))
            }

            saleToAcquirerData = SaleToAcquirerData().apply {
                additionalData = authType
                tenderOption = "ReceiptHandler"
            }
        }

    }

    private fun buildMessageHeader(
        saleID: String,
        serviceID: String,
        messageCategory: MessageCategoryType,
        poiid: String
    ): MessageHeader {
        return MessageHeader().apply {
            this.messageClass = MessageClassType.SERVICE
            this.messageCategory = messageCategory
            this.messageType = MessageType.REQUEST
            this.saleID = saleID
            this.serviceID = serviceID
            this.messageClass = MessageClassType.SERVICE
            this.protocolVersion = "3.0"
            this.poiid = poiid
        }
    }


    private fun getConfigurationData(
        terminalConfig: AdyenTerminalConfig
    ): Config {
        val config = Config()
        config.environment = if ("test".equals(
                terminalConfig.environment,
                ignoreCase = true
            )
        ) Environment.TEST else Environment.LIVE
        config.merchantAccount = terminalConfig.merchant_name
        val inputStream: InputStream? = context.get()?.assets?.open(terminalConfig.certPath)
        config.setTerminalCertificate(inputStream)
        config.connectionTimeoutMillis = 500000
        config.readTimeoutMillis = 500000
        config.terminalApiLocalEndpoint = terminalConfig.endpoint
        return config
    }

    private fun getConfigurationDataForMgmtAPI(
        terminalConfig: AdyenTerminalConfig
    ): Config {
        val config = Config()
        config.environment = if ("test".equals(
                terminalConfig.environment,
                ignoreCase = true
            )
        ) Environment.TEST else Environment.LIVE
        config.merchantAccount = terminalConfig.merchant_name
        config.connectionTimeoutMillis = 10000
        config.readTimeoutMillis = 10000
        config.posTerminalManagementApiEndpoint = if(config.environment == Environment.TEST) Client.POS_TERMINAL_MANAGEMENT_ENDPOINT_TEST else Client.POS_TERMINAL_MANAGEMENT_ENDPOINT_LIVE
        config.apiKey = terminalConfig.apiKey
        return config
    }

    private fun getSecurityKey(keyIdentifier: String, passphrase: String): SecurityKey {
        val securityKey = SecurityKey()
        securityKey.adyenCryptoVersion = 1
        securityKey.keyIdentifier = keyIdentifier
        securityKey.passphrase = passphrase
        securityKey.keyVersion = 1
        return securityKey
    }

    private fun bitmapToByteArray(bitmap : Bitmap) : ByteArray{
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 10, stream)
        val byteArray: ByteArray = stream.toByteArray()
        bitmap.recycle()
        return byteArray
    }
}