package com.ovaom.flutter_libpd.pd_controller.pd_audio_manager

import android.content.Context
import org.puredata.android.io.PdAudio
import java.io.IOException

class PdAudioManagerImpl(private val context: Context) : PdAudioManager {

    override fun startAudio() {
        PdAudio.startAudio(context)
    }

    override fun stopAudio() {
        PdAudio.stopAudio()
    }

    override fun configurePlayback(configuration: PlaybackConfiguration) {
        try {
            PdAudio.initAudio(
                configuration.sampleRate,
                configuration.inputNumberOfChannels,
                configuration.outputNumberOfChannels,
                8,
                true
            )
        } catch (error: IOException) {
            throw AudioError.ConfigurationFailed
        }
    }
}