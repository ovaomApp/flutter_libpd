package com.ovaom.flutter_libpd.pd_controller.pd_messenger

import org.puredata.core.PdBase

class PdMessengerImpl: PdMessenger {

    private fun ensureSuccessStatus(status: Int) {
        if (status != 0) throw MessageError.MessageFailed
    }

    override fun sendFloat(message: FloatMessage) {
        val status = PdBase.sendFloat(message.receiver, message.value)
        ensureSuccessStatus(status)
    }

    override fun sendBang(message: BangMessage) {
        val status = PdBase.sendBang(message.receiver)
        ensureSuccessStatus(status)
    }

    override fun sendSymbol(message: SymbolMessage) {
        val status = PdBase.sendSymbol(message.receiver, message.value)
        ensureSuccessStatus(status)
    }

    override fun sendList(message: ListMessage) {
        val status = PdBase.sendList(message.receiver, *message.value.toTypedArray())
        ensureSuccessStatus(status)
    }

    override fun sendMessage(message: ArgumentMessage) {
        val status = PdBase.sendMessage(message.receiver, message.value, *message.arguments.toTypedArray())
        ensureSuccessStatus(status)
    }
}