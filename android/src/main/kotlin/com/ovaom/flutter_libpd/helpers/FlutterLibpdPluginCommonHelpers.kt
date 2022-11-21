package com.ovaom.flutter_libpd.helpers

import com.ovaom.flutter_libpd.FlutterLibpdPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

fun FlutterLibpdPlugin.dispose(result: Result) {
    pdController.dispose()
    result.success(null)
}

fun FlutterLibpdPlugin.getAbsolutePath(call: MethodCall, result: Result) {
    val filename =
        call.arguments as? String ?: return result.error(
            "INVALID_PARAMETERS",
            "Expected parameter: String",
            call.arguments
        )

    val pdFile = File("$filesDir$filename")
    result.success(if (pdFile.exists()) pdFile.absolutePath else null)
}
