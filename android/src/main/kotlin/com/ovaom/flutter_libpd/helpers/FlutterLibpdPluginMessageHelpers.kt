package com.ovaom.flutter_libpd.helpers

import com.ovaom.flutter_libpd.FlutterLibpdPlugin
import com.ovaom.flutter_libpd.pd_controller.pd_messenger.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result


private const val valueKey = "value"
private const val symbolKey = "symbol"
private const val listKey = "list"
private const val messageKey = "message"
private const val argumentsKey = "arguments"
private const val receiverKey = "receiver"

// region Send Float
fun FlutterLibpdPlugin.sendFloat(call: MethodCall, result: Result) {
    val message =
        makeFloatMessage(call) ?: return result.error(
            "INVALID_PARAMETERS",
            "Expected parameters: [\"$valueKey\": Double, \"$receiverKey\": String]",
            call.arguments
        )
    try {
        pdController.sendFloat(message)
        result.success(null)
    } catch (error: Exception) {
        result.error("SEND_FLOAT_FAILED", "unable to send float", call.arguments)
    }
}

private fun makeFloatMessage(call: MethodCall): FloatMessage? {
    val value = call.argument<Double>(valueKey) ?: return null
    val receiver = call.argument<String>(receiverKey) ?: return null
    return FloatMessage(value.toFloat(), receiver)
}
// endregion

// region Send Bang
fun FlutterLibpdPlugin.sendBang(call: MethodCall, result: Result) {
    val receiver =
        call.arguments as? String ?: return result.error(
            "INVALID_PARAMETERS",
            "Expected parameter: String",
            call.arguments
        )
    try {
        pdController.sendBang(BangMessage(receiver))
        result.success(null)
    } catch (error: Exception) {
        result.error("SEND_BANG_FAILED", "unable to send bang", call.arguments)
    }
}
// endregion

// region Send Symbol
fun FlutterLibpdPlugin.sendSymbol(call: MethodCall, result: Result) {
    val message =
        makeSymbolMessage(call) ?: return result.error(
            "INVALID_PARAMETERS",
            "Expected parameters: [\"$symbolKey\": String, \"$receiverKey\": String]",
            call.arguments
        )
    try {
        pdController.sendSymbol(message)
        result.success(null)
    } catch (error: Exception) {
        result.error("SEND_SYMBOL_FAILED", "unable to send symbol", call.arguments)
    }
}

private fun makeSymbolMessage(call: MethodCall): SymbolMessage? {
    val symbol = call.argument<String>(symbolKey) ?: return null
    val receiver = call.argument<String>(receiverKey) ?: return null
    return SymbolMessage(symbol, receiver)
}
// endregion

// region Send List
fun FlutterLibpdPlugin.sendList(call: MethodCall, result: Result) {
    val message =
        makeListMessage(call) ?: return result.error(
            "INVALID_PARAMETERS",
            "Expected parameters: [\"$listKey\": [Any], \"$receiverKey\": String]",
            call.arguments
        )
    try {
        pdController.sendList(message)
        result.success(null)
    } catch (error: Exception) {
        result.error("SEND_LIST_FAILED", "unable to send list", call.arguments)
    }
}

private fun makeListMessage(call: MethodCall): ListMessage? {
    val list = call.argument<List<Any>>(listKey) ?: return null
    val receiver = call.argument<String>(receiverKey) ?: return null
    return ListMessage(list, receiver)
}
// endregion

// region Send Message
fun FlutterLibpdPlugin.sendMessage(call: MethodCall, result: Result) {
    val message =
        makeArgumentMessage(call) ?: return result.error(
            "INVALID_PARAMETERS",
            "Expected parameters: [\"$messageKey\": String, \"$argumentsKey\": [Any], \"$receiverKey\": String]",
            call.arguments
        )
    try {
        pdController.sendMessage(message)
        result.success(null)
    } catch (error: Exception) {
        result.error("SEND_MESSAGE_FAILED", "unable to send message", call.arguments)
    }
}

private fun makeArgumentMessage(call: MethodCall): ArgumentMessage? {
    val message = call.argument<String>(messageKey) ?: return null
    val arguments = call.argument<List<Any>>(argumentsKey) ?: return null
    val receiver = call.argument<String>(receiverKey) ?: return null
    return ArgumentMessage(message, arguments, receiver)
}
// endregion