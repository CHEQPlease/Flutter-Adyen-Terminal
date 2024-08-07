package com.cheqplease.adyen_terminal

import android.content.Context
import android.graphics.Bitmap
import android.util.Base64
import android.util.Base64.encodeToString
import android.util.Log
import com.adyen.Client
import com.adyen.Config
import com.adyen.enums.Environment
import com.adyen.httpclient.TerminalLocalAPIHostnameVerifier
import com.adyen.model.nexo.AbortRequest
import com.adyen.model.nexo.AdminRequest
import com.adyen.model.nexo.AmountsReq
import com.adyen.model.nexo.DeviceType
import com.adyen.model.nexo.DiagnosisRequest
import com.adyen.model.nexo.DisplayOutput
import com.adyen.model.nexo.DocumentQualifierType
import com.adyen.model.nexo.ForceEntryModeType
import com.adyen.model.nexo.InfoQualifyType
import com.adyen.model.nexo.InputCommandType
import com.adyen.model.nexo.InputData
import com.adyen.model.nexo.InputRequest
import com.adyen.model.nexo.MessageCategoryType
import com.adyen.model.nexo.MessageClassType
import com.adyen.model.nexo.MessageHeader
import com.adyen.model.nexo.MessageReference
import com.adyen.model.nexo.MessageType
import com.adyen.model.nexo.OutputContent
import com.adyen.model.nexo.OutputFormatType
import com.adyen.model.nexo.OutputText
import com.adyen.model.nexo.PaymentRequest
import com.adyen.model.nexo.PaymentTransaction
import com.adyen.model.nexo.PredefinedContent
import com.adyen.model.nexo.PrintOutput
import com.adyen.model.nexo.PrintRequest
import com.adyen.model.nexo.ResponseModeType
import com.adyen.model.nexo.ResultType
import com.adyen.model.nexo.SaleData
import com.adyen.model.nexo.SaleToPOIRequest
import com.adyen.model.nexo.TokenRequestedType
import com.adyen.model.nexo.TransactionConditions
import com.adyen.model.nexo.TransactionIdentification
import com.adyen.model.posterminalmanagement.GetTerminalDetailsRequest
import com.adyen.model.posterminalmanagement.GetTerminalDetailsResponse
import com.adyen.model.terminal.SaleToAcquirerData
import com.adyen.model.terminal.TerminalAPIRequest
import com.adyen.model.terminal.TerminalAPIResponse
import com.adyen.model.terminal.security.SecurityKey
import com.adyen.service.PosTerminalManagementApi
import com.adyen.service.TerminalCloudAPI
import com.adyen.service.TerminalLocalAPI
import com.cheq.receiptify.Receiptify
import com.cheqplease.adyen_terminal.data.AdyenTerminalConfig
import com.cheqplease.adyen_terminal.data.CommunicationMode
import com.cheqplease.adyen_terminal.data.ErrorCode
import com.cheqplease.adyen_terminal.data.SignatureHandler
import com.cheqplease.adyen_terminal.data.TransactionFailureHandler
import com.cheqplease.adyen_terminal.data.TransactionSuccessHandler
import com.google.gson.Gson
import com.orhanobut.logger.AndroidLogAdapter
import com.orhanobut.logger.Logger
import com.orhanobut.logger.PrettyFormatStrategy
import org.apache.hc.client5.http.ConnectTimeoutException
import org.apache.hc.client5.http.HttpHostConnectException
import org.json.JSONObject
import java.io.ByteArrayOutputStream
import java.lang.ref.WeakReference
import java.math.BigDecimal
import java.math.BigInteger
import java.net.SocketTimeoutException
import java.security.KeyStore
import java.security.SecureRandom
import java.security.cert.Certificate
import java.security.cert.CertificateFactory
import java.util.GregorianCalendar
import java.util.TimeZone
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManagerFactory
import javax.xml.datatype.DatatypeFactory


object AdyenTerminalManager {

    private lateinit var terminalConfig: AdyenTerminalConfig
    private lateinit var context: WeakReference<Context>
    private const val LOG_TAG = "FLUTTER_ADYEN"
    private var loggerInitiated = false

    fun init(adyenTerminalConfig: AdyenTerminalConfig, context: Context) {
        terminalConfig = adyenTerminalConfig
        AdyenTerminalManager.context = WeakReference<Context>(context)
        initLogger()
    }

    private fun initLogger() {
        if (!loggerInitiated) {
            Logger.addLogAdapter(object : AndroidLogAdapter(
                PrettyFormatStrategy.newBuilder().tag(LOG_TAG).showThreadInfo(false).methodCount(3)
                    .build()
            ) {
                override fun isLoggable(priority: Int, tag: String?): Boolean {
                    return terminalConfig.showLogs
                }
            })
            loggerInitiated = true
        }
    }

    fun authorizeTransaction(
        transactionId: String,
        terminalId: String,
        captureType: String,
        currency: String,
        requestAmount: BigDecimal,
        additionalData: HashMap<String, Any>,
        forcedEntryModes: List<String> = emptyList(),
        paymentSuccessHandler: TransactionSuccessHandler<String?>,
        paymentFailureHandler: TransactionFailureHandler<Int, String>,
    ) {
        val terminalApiRequest = TerminalAPIRequest().apply {
            saleToPOIRequest = buildSalePOIRequest(
                saleID = terminalId,
                transactionId = transactionId,
                poiid = "${terminalConfig.terminalModelNo}-${terminalConfig.terminalSerialNo}",
                messageCategory = MessageCategoryType.PAYMENT,
                currency = currency,
                requestAmount = requestAmount,
                captureType = captureType,
                additionalData = additionalData,
                forcedEntryModes = forcedEntryModes
            )
        }

        Logger.d("ADYEN TERMINAL TRANSACTION REQUEST")
        Logger.json(Gson().toJson(terminalApiRequest))


        try {
            val response = sendTerminalRequest(terminalApiRequest)
            if (response != null) {
                val resultJson = Gson().toJson(response)
                val txnResult = response.saleToPOIResponse.paymentResponse.response.result

                val isTxnSuccessful =
                    txnResult == ResultType.SUCCESS || txnResult == ResultType.PARTIAL
                if (isTxnSuccessful) {
                    Logger.d("ADYEN TERMINAL TRANSACTION RESPONSE")
                    Logger.json(resultJson)
                    paymentSuccessHandler.onSuccess(resultJson)
                } else {
                    Logger.e("ADYEN TERMINAL TRANSACTION RESPONSE")
                    Logger.json(resultJson)
                    paymentFailureHandler.onFailure(ErrorCode.TRANSACTION_FAILURE, resultJson)
                }
            } else {
                Logger.e("ADYEN TERMINAL TRANSACTION RESPONSE")
                paymentFailureHandler.onFailure(ErrorCode.TRANSACTION_FAILURE, null)
            }
        } catch (e: Exception) {
            Logger.e("ADYEN TERMINAL TRANSACTION RESPONSE")
            Logger.e(e.message ?: "Unknown Error")
            when (e) {
                is ConnectTimeoutException -> paymentFailureHandler.onFailure(
                    ErrorCode.CONNECTION_TIMEOUT, e.message ?: "Connection timeout"
                )

                is SocketTimeoutException -> paymentFailureHandler.onFailure(
                    ErrorCode.TRANSACTION_TIMEOUT, e.message ?: "Transaction timed out"
                )

                is HttpHostConnectException -> paymentFailureHandler.onFailure(
                    ErrorCode.DEVICE_UNREACHABLE,
                    e.message ?: "Device Unreachable. Please check your internet connection"
                )

                else -> paymentFailureHandler.onFailure(
                    ErrorCode.TRANSACTION_FAILURE_OTHERS, e.message!!
                )
            }
        }
    }

    private fun sendTerminalRequest(terminalApiRequest: TerminalAPIRequest, config: Config = getConfigurationData(
        terminalConfig)): TerminalAPIResponse? {
        val communicationMode = terminalConfig.communicationMode
        return when (communicationMode) {
            CommunicationMode.LOCAL -> {
                val terminalLocalAPI = getTerminalLocalAPI(config)
                terminalLocalAPI.request(terminalApiRequest)
            }

            CommunicationMode.CLOUD -> {
                val terminalCloudAPI = getTerminalCloudAPI(config)
                terminalCloudAPI.sync(terminalApiRequest)
            }
        }
    }

    fun tokenizeCard(
        transactionId: String,
        requestedAmount: Double,
        currency: String,
        shopperEmail: String,
        shopperReference: String,
        forcedEntryModes: List<String> = emptyList(),
        successHandler: TransactionSuccessHandler<String>,
        failureHandler: TransactionFailureHandler<Int, String>
    ) {


        val terminalApiRequest = TerminalAPIRequest().apply {
            saleToPOIRequest = SaleToPOIRequest().apply {

                messageHeader = MessageHeader().apply {
                    protocolVersion = "3.0"
                    messageClass = MessageClassType.SERVICE
                    messageCategory = MessageCategoryType.PAYMENT
                    messageType = MessageType.REQUEST
                    serviceID = transactionId
                    saleID = terminalConfig.terminalId
                    poiid = "${terminalConfig.terminalModelNo}-${terminalConfig.terminalSerialNo}"
                }

                paymentRequest = PaymentRequest().apply {
                    saleData = SaleData().apply {
                        saleTransactionID = TransactionIdentification().apply {
                            transactionID = transactionId
                            timeStamp = DatatypeFactory.newInstance()
                                .newXMLGregorianCalendar(GregorianCalendar(TimeZone.getDefault()))
                        }

                        saleToAcquirerData = SaleToAcquirerData().apply {
                            recurringProcessingModel =
                                SaleToAcquirerData.RecurringProcessingModelEnum.UNSCHEDULED_CARD_ON_FILE
                            this.shopperEmail = shopperEmail
                            this.shopperReference = shopperReference
                        }
                        tokenRequestedType = TokenRequestedType.CUSTOMER
                    }

                    val forcedEntryModesEnumList = forcedEntryModes.map {
                        ForceEntryModeType.fromValue(it)
                    }

                    paymentTransaction = PaymentTransaction().apply {
                        amountsReq = AmountsReq().apply {
                            this.currency = currency
                            this.requestedAmount = BigDecimal(requestedAmount)
                        }

                        transactionConditions = TransactionConditions().apply {
                            forceEntryMode.addAll(forcedEntryModesEnumList)
                        }
                    }
                }
            }
        }


        try {

            Logger.d("ADYEN TERMINAL TRANSACTION REQUEST")
            Logger.json(Gson().toJson(terminalApiRequest))

            val response = sendTerminalRequest(terminalApiRequest)
            if (response != null) {
                val resultJson = Gson().toJson(response)
                val txnResult = response.saleToPOIResponse.paymentResponse.response.result

                val isTxnSuccessful =
                    txnResult == ResultType.SUCCESS || txnResult == ResultType.PARTIAL
                if (isTxnSuccessful) {
                    Logger.d("ADYEN TERMINAL TRANSACTION RESPONSE")
                    Logger.json(resultJson)
                    successHandler.onSuccess(resultJson)
                } else {
                    Logger.e("ADYEN TERMINAL TRANSACTION RESPONSE")
                    Logger.json(resultJson)
                    failureHandler.onFailure(ErrorCode.FAILED_TO_TOKENIZE, resultJson)
                }
            } else {
                Logger.e("ADYEN TERMINAL TRANSACTION RESPONSE")
                failureHandler.onFailure(ErrorCode.FAILED_TO_TOKENIZE, null)
            }
        } catch (e: Exception) {
            Logger.e("ADYEN TERMINAL TRANSACTION RESPONSE")
            Logger.e(e.message ?: "Unknown Error")
            when (e) {
                is ConnectTimeoutException -> failureHandler.onFailure(
                    ErrorCode.CONNECTION_TIMEOUT, e.message ?: "Connection timeout"
                )

                is SocketTimeoutException -> failureHandler.onFailure(
                    ErrorCode.TRANSACTION_TIMEOUT, e.message ?: "Transaction timed out"
                )

                is HttpHostConnectException -> failureHandler.onFailure(
                    ErrorCode.DEVICE_UNREACHABLE,
                    e.message ?: "Device Unreachable. Please check your internet connection"
                )

                else -> failureHandler.onFailure(ErrorCode.FAILED_TO_TOKENIZE, e.message!!)
            }
        }
    }


    fun getSignature(transactionId: String, signatureHandler: SignatureHandler?) {

        val terminalApiRequest = TerminalAPIRequest().apply {
            saleToPOIRequest = SaleToPOIRequest().apply {
                messageHeader = MessageHeader().apply {
                    messageClass = MessageClassType.DEVICE
                    messageCategory = MessageCategoryType.INPUT
                    messageType = MessageType.REQUEST
                    serviceID = transactionId
                    saleID = terminalConfig.terminalId
                    protocolVersion = "3.0"
                    poiid = "${terminalConfig.terminalModelNo}-${terminalConfig.terminalSerialNo}"
                }
                inputRequest = buildInputRequest()
            }
        }


        try {
            val response = sendTerminalRequest(terminalApiRequest)
            val signatureData = response?.saleToPOIResponse?.inputResponse?.inputResult?.response

            if (signatureData?.result == ResultType.SUCCESS && signatureData.additionalResponse != null) {
                val encodedText = signatureData.additionalResponse
                val decodedText = Utils.decodeUrlEncodedString(encodedText)
                val responseData = Utils.getResponseDataValue(decodedText)

                signatureHandler?.onSignatureReceived(signature = responseData)
            } else {
                signatureHandler?.onSignatureRejected()
            }
        } catch (e: Exception) {
            if (BuildConfig.DEBUG) {
                e.printStackTrace()
            }
            signatureHandler?.onSignatureRejected()
        }
    }

    private fun getTerminalCloudAPI(config: Config): TerminalCloudAPI {
        val terminalLocalAPIClient = Client(config)
        return TerminalCloudAPI(terminalLocalAPIClient)
    }

    private fun getTerminalLocalAPI(config: Config): TerminalLocalAPI {
        val terminalLocalAPIClient = Client(config)
        return TerminalLocalAPI(terminalLocalAPIClient, getSecurityKey())
    }


    fun cancelTransaction(terminalId: String, transactionId: String, txnIdToCancel: String) {

        val terminalApiRequest = TerminalAPIRequest()
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

        Logger.d("ADYEN TERMINAL CANCEL REQUEST")
        Logger.json(Gson().toJson(terminalApiRequest))

        val response = sendTerminalRequest(terminalApiRequest)
        Logger.d("ADYEN TERMINAL CANCEL RESPONSE")
        Logger.json(Gson().toJson(response))
    }


    fun printReceipt(
        context: Context,
        transactionId: String,
        receiptDTOJSON: String,
        successHandler: TransactionSuccessHandler<Void>,
        failureHandler: TransactionFailureHandler<Int, String>
    ) {
        try {

            Receiptify.init(context)
            val customerReceiptBitmap = Receiptify.buildReceipt(receiptDTOJSON)
            val encoded: ByteArray? = customerReceiptBitmap?.let { bitmapToByteArray(bitmap = it) }
            val imageBase64Encoded = encodeToString(encoded, Base64.DEFAULT)
            val printData =
                """<?xml version="1.0" encoding="UTF-8"?><img src="data:image/png;base64, $imageBase64Encoded"/>""".trimIndent()

            val config: Config = getConfigurationData(terminalConfig)
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

            val response = sendTerminalRequest(terminalApiRequest)

            val isPrinted =
                response?.saleToPOIResponse?.printResponse?.response?.result == ResultType.SUCCESS

            if (isPrinted) {
                Logger.d("ADYEN TERMINAL PRINT RESPONSE", "Printing Successful")
                successHandler.onSuccess(null)
            } else {
                val errorMsg =
                    response?.saleToPOIResponse?.printResponse?.response?.additionalResponse
                failureHandler.onFailure(ErrorCode.FAILURE_GENERIC, errorMsg)
            }

        } catch (e: Exception) {
            if (e.message != null) {
                failureHandler.onFailure(
                    ErrorCode.FAILURE_GENERIC, "Printing Failed ${e.message!!}"
                )
            } else {
                failureHandler.onFailure(ErrorCode.FAILURE_GENERIC, "Printing Failed")
            }
        }
    }


    fun getTerminalInfo(
        terminalIP: String,
        txnId: String,
        successHandler: TransactionSuccessHandler<String>,
        failureHandler: TransactionFailureHandler<Int, String>
    ) {

        val config: Config = getConfigurationData(terminalConfig)
        config.apply {
            terminalApiLocalEndpoint = terminalIP
        }

        val terminalApiRequest = TerminalAPIRequest()
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
            val response = sendTerminalRequest(terminalApiRequest, config)
            val resultJSONString = Gson().toJson(response?.saleToPOIResponse)
            val terminalDetailsJSON = JSONObject()
            val saleToPoiJsonObject = JSONObject(resultJSONString)
            terminalDetailsJSON.put("SaleToPOIResponse", saleToPoiJsonObject)

            //Get Verbose TerminalInfo from Web Mgmt API
            try {
                val terminalDetails =
                    response?.saleToPOIResponse?.messageHeader?.poiid?.let { getTerminalDetails(it) }
                val webApiResponseJSON = Gson().toJson(terminalDetails)
                val webApiResponseJSONObject = JSONObject(webApiResponseJSON)
                terminalDetailsJSON.put("WebAPIResponse", webApiResponseJSONObject)
                Log.d("terminalMgmtAPIResponse", " : $terminalDetails")
                successHandler.onSuccess(terminalDetailsJSON.toString())
            } catch (e: Exception) {
                Log.d("terminalMgmtAPIResponse", " : Failed to get WebApiResponse")
                successHandler.onSuccess(terminalDetailsJSON.toString())
            }
        } catch (e: Exception) {
            Log.d("terminalMgmtAPIResponse", " : Error occurred retrieving terminal info.")
            failureHandler.onFailure(
                ErrorCode.FAILURE_GENERIC, e.message ?: "Error occurred retrieving terminal info."
            )
        }

    }


    private fun getTerminalDetails(poiid: String): GetTerminalDetailsResponse {
        val config: Config = getConfigurationDataForMgmtAPI(terminalConfig)
        val terminalMgmtClient = Client(config)
        val terminalMgmtAPI = PosTerminalManagementApi(terminalMgmtClient)

        val getTerminalDetailsRequest: GetTerminalDetailsRequest =
            GetTerminalDetailsRequest().apply {
                terminal = poiid
            }

        return terminalMgmtAPI.getTerminalDetails(getTerminalDetailsRequest)
    }


    fun scanBarcode(transactionId: String) {

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

        val jsonBase64 = encodeToString(jsonReq.toByteArray(), Base64.DEFAULT)

        getConfigurationData(terminalConfig)
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
            sendTerminalRequest(terminalApiRequest)
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
        captureType: String,
        additionalData: HashMap<String, Any>,
        forcedEntryModes: List<String> = emptyList()
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
                captureType = captureType,
                additionalData = additionalData,
                forcedEntryModes = forcedEntryModes
            )
            inputRequest = buildInputRequest()
        }

    }

    private fun buildInputRequest(): InputRequest {
        return InputRequest().apply {
            displayOutput = DisplayOutput().apply {
                device = DeviceType.CUSTOMER_DISPLAY
                infoQualify = InfoQualifyType.DISPLAY
                outputContent = OutputContent().apply {
                    outputFormat = OutputFormatType.TEXT
                    predefinedContent = PredefinedContent().apply {
                        referenceID = "GetSignature"
                    }
                    outputText.add(OutputText().apply {
                        text = "Please sign"
                    })

                    outputText.add(OutputText().apply {
                        text = ""
                    })
                }

                inputData = InputData().apply {
                    device = DeviceType.CUSTOMER_INPUT
                    infoQualify = InfoQualifyType.INPUT
                    inputCommand = InputCommandType.GET_CONFIRMATION
                    maxInputTime = BigInteger.valueOf(30)
                }
            }
        }
    }

    private fun buildPaymentRequest(
        currency: String,
        requestAmount: BigDecimal,
        transactionId: String,
        captureType: String,
        additionalData: HashMap<String, Any>?,
        forcedEntryModes: List<String> = emptyList()
    ): PaymentRequest {
        return PaymentRequest().apply {
            saleData = buildSaleData(
                transactionId = transactionId,
                captureType = captureType,
                additionalMetaData = additionalData
            )
            paymentTransaction = buildPaymentTransaction(
                currency = currency,
                requestAmount = requestAmount,
                forcedEntryModes = forcedEntryModes
            )

        }
    }

    private fun buildPaymentTransaction(
        currency: String, requestAmount: BigDecimal, forcedEntryModes: List<String> = emptyList()
    ): PaymentTransaction {

        val forcedEntryModesEnumList = forcedEntryModes.map {
            ForceEntryModeType.fromValue(it)
        }

        return PaymentTransaction().apply {
            amountsReq = AmountsReq().apply {
                this.currency = currency
                this.requestedAmount = requestAmount
            }

            transactionConditions = TransactionConditions().apply {
                forceEntryMode.addAll(forcedEntryModesEnumList)
            }
        }
    }

    private fun buildSaleData(
        transactionId: String, captureType: String, additionalMetaData: HashMap<String, Any>?
    ): SaleData {

        val authType = if ("immediate".equals(
                captureType, ignoreCase = true
            )
        ) mapOf("authorisationType" to "FinalAuth") else mapOf("authorisationType" to "PreAuth")


        return SaleData().apply {
            saleTransactionID = TransactionIdentification().apply {
                transactionID = transactionId
                timeStamp = DatatypeFactory.newInstance()
                    .newXMLGregorianCalendar(GregorianCalendar(TimeZone.getDefault()))
            }

            saleToAcquirerData = SaleToAcquirerData().apply {
                additionalData = authType
                tenderOption = "ReceiptHandler"
                shopperStatement =
                    if ((additionalMetaData != null) && additionalMetaData.containsKey("shopperStatement")) additionalMetaData["shopperStatement"] as String else ""
            }
        }

    }

    private fun buildMessageHeader(
        saleID: String, serviceID: String, messageCategory: MessageCategoryType, poiid: String
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


    private fun getConfigurationData(terminalConfig: AdyenTerminalConfig): Config {
        return Config().apply {
            environment = determineEnvironment(terminalConfig.environment)
            connectionTimeoutMillis = terminalConfig.connectionTimeoutMillis
            readTimeoutMillis = terminalConfig.readTimeoutMillis

            when (terminalConfig.communicationMode) {
                CommunicationMode.LOCAL -> configureLocalIntegration(terminalConfig, this)
                CommunicationMode.CLOUD -> configureCloudIntegration(terminalConfig, this)
            }
        }
    }

    private fun determineEnvironment(envString: String): Environment =
        if (envString.equals("live", ignoreCase = true)) Environment.LIVE else Environment.TEST

    private fun configureLocalIntegration(terminalConfig: AdyenTerminalConfig, config: Config) {
        config.apply {
            terminalApiLocalEndpoint = terminalConfig.endpoint
            hostnameVerifier = TerminalLocalAPIHostnameVerifier(environment)
            sslContext = createSSLContext(terminalConfig.certPath)
        }
    }

    private fun createSSLContext(certPath: String): SSLContext {
        val keyStore = KeyStore.getInstance(KeyStore.getDefaultType()).apply {
            load(null, null)
            setCertificateEntry("adyenRootCertificate", loadCertificate(certPath))
        }

        val trustManagerFactory =
            TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm()).apply {
                init(keyStore)
            }

        return SSLContext.getInstance("SSL").apply {
            init(null, trustManagerFactory.trustManagers, SecureRandom())
        }
    }

    private fun loadCertificate(certPath: String): Certificate {
        val certificateFactory = CertificateFactory.getInstance("X.509")
        return context.get()?.assets?.open(certPath)?.use { inputStream ->
            certificateFactory.generateCertificate(inputStream)
        } ?: throw IllegalStateException("Failed to load certificate")
    }

    private fun configureCloudIntegration(terminalConfig: AdyenTerminalConfig, config: Config) {
        config.apply {
            terminalApiCloudEndpoint = when (environment) {
                Environment.TEST -> Client.TERMINAL_API_ENDPOINT_TEST
                Environment.LIVE -> Client.TERMINAL_API_ENDPOINT_LIVE
            }
            terminalApiCloudEndpoint = terminalConfig.endpoint
            apiKey = terminalConfig.backendApiKey
        }
    }

    private fun getConfigurationDataForMgmtAPI(
        terminalConfig: AdyenTerminalConfig
    ): Config {
        val config = Config()
        config.environment = if ("test".equals(
                terminalConfig.environment, ignoreCase = true
            )
        ) Environment.TEST else Environment.LIVE
//        config. = terminalConfig.merchantName
        config.connectionTimeoutMillis = 10000
        config.readTimeoutMillis = 10000
        config.terminalApiLocalEndpoint =
            if (config.environment == Environment.TEST) Client.TERMINAL_API_ENDPOINT_TEST else Client.TERMINAL_API_ENDPOINT_LIVE
        config.apiKey = terminalConfig.backendApiKey
        return config
    }

    private fun getSecurityKey(): SecurityKey {
        val securityKey = SecurityKey()
        securityKey.adyenCryptoVersion = 1
        securityKey.keyIdentifier = terminalConfig.keyId
        securityKey.passphrase = terminalConfig.keyPassphrase
        securityKey.keyVersion = 1
        return securityKey
    }

    private fun bitmapToByteArray(bitmap: Bitmap): ByteArray {
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 10, stream)
        val byteArray: ByteArray = stream.toByteArray()
        bitmap.recycle()
        return byteArray
    }


}