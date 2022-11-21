package com.ovaom.flutter_libpd.helpers

import com.ovaom.flutter_libpd.FlutterLibpdPlugin
import com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager.PatchFile
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

fun FlutterLibpdPlugin.openPatch(call: MethodCall, result: Result) {
    val patchFile =
        makePatchFile(call) ?: return deliverInvalidParamsError(result, call.arguments)
    try {
        pdController.openPatch(patchFile)
        result.success(null)
    } catch (error: Exception) {
        result.error(
            "OPEN_PATCH_FAILED",
            "unable to open patch: ${patchFile.fullPath}",
            call.arguments
        )
    }
}

fun FlutterLibpdPlugin.closePatch(call: MethodCall, result: Result) {
    val patchFile =
        makePatchFile(call) ?: return deliverInvalidParamsError(result, call.arguments)
    pdController.closePatch(patchFile)
    result.success(null)
}

private fun deliverInvalidParamsError(result: Result, arguments: Any) {
    result.error(
        "INVALID_PARAMETERS",
        "Expected parameters: ['patchName': String, 'path': String]", arguments
    )
}

private fun makePatchFile(call: MethodCall): PatchFile? {
    val patchName = call.argument<String>("patchName") ?: return null
    val path = call.argument<String>("path") ?: return null
    return PatchFile(patchName, path)
}