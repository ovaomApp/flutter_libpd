package com.ovaom.flutter_libpd_example.helpers_test

import com.ovaom.flutter_libpd.pd_controller.pd_audio_manager.PlaybackConfiguration
import com.ovaom.flutter_libpd.pd_controller.pd_messenger.*

fun anyFloatMessage(): FloatMessage {
    return FloatMessage(anyFloatValue(), anyReceiver())
}

fun anyBangMessage(): BangMessage {
    return BangMessage(anyReceiver())
}

fun anySymbolMessage(): SymbolMessage {
    return SymbolMessage(anyStringValue(), anyReceiver())
}

fun anyListMessage(): ListMessage {
    return ListMessage(listOf<Any>(anyFloatValue(), anyStringValue()), anyReceiver())
}

fun anyBaseMessage(): ArgumentMessage {
    return ArgumentMessage(anyStringValue(), listOf<Any>(anyStringValue(), anyFloatValue()), anyReceiver())
}

fun anyFloatValue(): Float {
    return 0.5.toFloat()
}

fun anyReceiver(): String {
    return "anyReceiver"
}

fun anyStringValue(): String {
    return "anyString"
}

fun anyPlaybackConfiguration(): PlaybackConfiguration {
    return PlaybackConfiguration(44100,
            1,
            1)
}