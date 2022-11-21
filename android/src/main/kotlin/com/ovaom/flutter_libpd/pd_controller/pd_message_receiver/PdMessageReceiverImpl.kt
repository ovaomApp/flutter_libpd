package com.ovaom.flutter_libpd.pd_controller.pd_message_receiver

import org.puredata.android.utils.PdUiDispatcher
import org.puredata.core.PdBase
import org.puredata.core.PdListener
import org.puredata.core.utils.PdDispatcher

class PdMessageReceiverImpl(private val dispatcher: PdDispatcher = PdUiDispatcher()): PdMessageReceiver, PdListener {
    private var callbacks = mutableMapOf<String, ListenerCallback>()

    init {
        PdBase.setReceiver(dispatcher)
    }

    override fun addListener(source: String, callback: ListenerCallback) {
        if (!callbacks.containsKey(source)) {
            dispatcher.addListener(source, this)
        }
        callbacks[source] = callback
    }

    override fun removeListener(source: String) {
        callbacks.remove(source)
        dispatcher.removeListener(source, this)
    }

    override fun removeAllListeners() {
        callbacks.keys.forEach { removeListener(it) }
    }

    override fun dispose() {
        removeAllListeners()
        PdBase.setReceiver(null)
    }

    override fun receiveBang(source: String) {
        callbacks[source]?.invoke(ReceivedEvent(source))
    }

    override fun receiveFloat(source: String, x: Float) {
        callbacks[source]?.invoke(ReceivedEvent(source, arguments = listOf(x)))
    }

    override fun receiveSymbol(source: String, symbol: String) {
        callbacks[source]?.invoke(ReceivedEvent(source, symbol))
    }

    override fun receiveList(source: String, vararg args: Any) {
        callbacks[source]?.invoke(ReceivedEvent(source, arguments = args.toList()))
    }

    override fun receiveMessage(source: String, symbol: String, vararg args: Any) {
        callbacks[source]?.invoke(ReceivedEvent(source, symbol, args.toList()))
    }
}