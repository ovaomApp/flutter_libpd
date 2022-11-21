package com.ovaom.flutter_libpd.pd_controller.pd_messenger

interface PdMessenger {
    fun sendFloat(message: FloatMessage)
    fun sendBang(message: BangMessage)
    fun sendSymbol(message: SymbolMessage)
    fun sendList(message: ListMessage)
    fun sendMessage(message: ArgumentMessage)
}

sealed class MessageError : Exception() {
    object MessageFailed: MessageError()
}

data class FloatMessage(val value: Float, val receiver: String)
data class BangMessage(val receiver: String)
data class SymbolMessage(val value: String, val receiver: String)
data class ListMessage(val value: List<Any>, val receiver: String)
data class ArgumentMessage(val value: String, val arguments: List<Any>, val receiver: String)