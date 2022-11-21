package com.ovaom.flutter_libpd.event_channel

import com.ovaom.flutter_libpd.pd_controller.pd_message_receiver.PdMessageReceiver
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler

class ReceiveMessageStreamHandler(private val messageReceiver: PdMessageReceiver) : StreamHandler {

    override fun onListen(arguments: Any?, events: EventSink) {
        val source = makeSource(arguments) ?: return deliverInvalidParamsError(arguments, events)
        messageReceiver.addListener(source) {
            events.success(
                mapOf(
                    "source" to it.source,
                    "symbol" to it.symbol,
                    "value" to it.arguments
                )
            )
        }
    }

    override fun onCancel(arguments: Any?) {
        makeSource(arguments)?.let {
            messageReceiver.removeListener(it)
        }
    }

    private fun deliverInvalidParamsError(arguments: Any?, events: EventSink) {
        events.error("INVALID_PARAMETERS", "Expected param: [String] of size 1", arguments)
    }

    private fun makeSource(arguments: Any?): String? {
        (arguments as? List<*>)?.filterIsInstance<String>()?.let {
            if (it.size == 1 && it[0].isNotEmpty()) { return it[0] }
        }
        return null
    }
}