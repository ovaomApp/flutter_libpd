package com.ovaom.flutter_libpd.pd_controller

import com.ovaom.flutter_libpd.pd_controller.pd_audio_manager.PdAudioManager
import com.ovaom.flutter_libpd.pd_controller.pd_audio_manager.PlaybackConfiguration
import com.ovaom.flutter_libpd.pd_controller.pd_messenger.*
import com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager.PatchFile
import com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager.PdPatchFileManager

class PdController(private val messenger: PdMessenger,
                   private val patchManager: PdPatchFileManager,
                   private val audioManager: PdAudioManager) {

    fun sendFloat(message: FloatMessage) {
        messenger.sendFloat(message)
    }

    fun sendBang(message: BangMessage) {
        messenger.sendBang(message)
    }

    fun sendSymbol(message: SymbolMessage) {
        messenger.sendSymbol(message)
    }

    fun sendList(message: ListMessage) {
        messenger.sendList(message)
    }

    fun sendMessage(message: ArgumentMessage) {
        messenger.sendMessage(message)
    }

    fun openPatch(file: PatchFile) {
        patchManager.openPatch(file)
    }

    fun closePatch(file: PatchFile) {
        patchManager.closePatch(file)
    }

    fun startAudio() {
        audioManager.startAudio()
    }

    fun stopAudio() {
        audioManager.stopAudio()
    }

    fun configurePlayback(configuration: PlaybackConfiguration) {
        audioManager.configurePlayback(configuration)
    }

    fun dispose() {
        stopAudio()
        patchManager.openedPatches.forEach { closePatch(it) }
    }
}