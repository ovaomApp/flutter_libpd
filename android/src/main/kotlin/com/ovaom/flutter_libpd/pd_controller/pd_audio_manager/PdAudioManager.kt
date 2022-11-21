package com.ovaom.flutter_libpd.pd_controller.pd_audio_manager

interface PdAudioManager {
    fun startAudio()
    fun stopAudio()
    fun configurePlayback(configuration: PlaybackConfiguration)
}

data class PlaybackConfiguration(
    val sampleRate: Int,
    val inputNumberOfChannels: Int,
    val outputNumberOfChannels: Int
)

sealed class AudioError : Exception() {
    object ConfigurationFailed : AudioError()
}
