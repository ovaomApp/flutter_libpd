package com.ovaom.flutter_libpd.pd_controller.pd_message_receiver

interface PdMessageReceiver {
    fun addListener(source: String, callback: ListenerCallback)
    fun removeListener(source: String)
    fun removeAllListeners()
    fun dispose()
}

typealias ListenerCallback = (ReceivedEvent) -> Unit

data class ReceivedEvent(val source: String, val symbol: String? = null, val arguments: List<Any>? = null)
