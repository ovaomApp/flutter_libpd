package com.ovaom.flutter_libpd.helpers

import com.ovaom.flutter_libpd.FlutterLibpdPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.puredata.core.utils.IoUtils
import java.io.File
import java.io.InputStream

fun FlutterLibpdPlugin.unzip(call: MethodCall, result: Result) {
    val request = makeUnzipRequest(call) ?: return result.error(
        "INVALID_PARAMETERS",
        "Expected parameters: ['filename': String, 'packageName': String, 'resourceType': String]",
        call.arguments
    )
    val resId =
        resources.getIdentifier(request.filename, request.resourceType, request.packageName)

    scope.launch {
        try {
            unzipFile(resources.openRawResource(resId), filesDir)
            result.success(null)
        } catch (error: Exception) {
            result.error("UNZIP_FILE_FAILED", "unable to unzip file", call.arguments)
        }
    }
}

private suspend fun unzipFile(
    inputStream: InputStream,
    directory: File,
    overwrite: Boolean = true
) = withContext(Dispatchers.IO) {
    IoUtils.extractZipResource(inputStream, directory, overwrite)
}

private fun makeUnzipRequest(call: MethodCall): UnzipRequest? {
    val filename = call.argument<String>("filename") ?: return null
    val packageName = call.argument<String>("packageName") ?: return null
    val resourceType = call.argument<String>("resourceType") ?: return null
    return UnzipRequest(filename, packageName, resourceType)
}


data class UnzipRequest(val filename: String, val packageName: String, val resourceType: String)
