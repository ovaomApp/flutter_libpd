package com.ovaom.flutter_libpd.helpers

import com.ovaom.flutter_libpd.FlutterLibpdPlugin
import com.ovaom.flutter_libpd.pd_controller.pd_audio_manager.PlaybackConfiguration
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import org.puredata.android.io.AudioParameters

fun FlutterLibpdPlugin.startAudio(result: Result) {
    pdController.startAudio()
    result.success(null)
}

fun FlutterLibpdPlugin.stopAudio(result: Result) {
    pdController.stopAudio()
    result.success(null)
}

fun FlutterLibpdPlugin.configurePlayback(call: MethodCall, result: Result) {
    val configuration = makePlaybackConfiguration(call) ?: return result.error("INVALID_PARAMETERS",
        "Expected parameters: [(required) 'inputEnabled': Bool, (optional) 'sampleRate': Int, " +
                "(optional) 'inputNumberOfChannels': Int, (optional) 'outputNumberOfChannels': Int]", call.arguments)
    try {
        pdController.configurePlayback(configuration)
        result.success(null)
    } catch (error: Exception) {
        result.error("CONFIGURE_PLAYBACK_FAILED", "unable to configure playback", call.arguments)
    }
}

private fun makePlaybackConfiguration(call: MethodCall): PlaybackConfiguration? {
    val inputEnabled = call.argument<Boolean>("inputEnabled") ?: return null
    val sampleRate = call.argument<Int>("sampleRate") ?: AudioParameters.suggestSampleRate()
    val inputNumberOfChannels = if (inputEnabled) call.argument<Int>("inputNumberOfChannels")
        ?: AudioParameters.suggestInputChannels() else 0
    val outputNumberOfChannels = call.argument<Int>("outputNumberOfChannels") ?: AudioParameters.suggestOutputChannels()
    return PlaybackConfiguration(sampleRate, inputNumberOfChannels, outputNumberOfChannels)
}