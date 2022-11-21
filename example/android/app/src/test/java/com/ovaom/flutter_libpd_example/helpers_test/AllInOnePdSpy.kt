package com.ovaom.flutter_libpd_example.helpers_test

import com.ovaom.flutter_libpd.pd_controller.pd_audio_manager.PdAudioManager
import com.ovaom.flutter_libpd.pd_controller.pd_audio_manager.PlaybackConfiguration
import com.ovaom.flutter_libpd.pd_controller.pd_messenger.*
import com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager.PatchFile
import com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager.PdPatchFileManager

class AllInOnePdSpy : PdMessenger, PdPatchFileManager, PdAudioManager {
    //TODO: private set
    var receivedMessages = mutableListOf<ReceivedMessage>()

    private fun throwErrorIfNeeded(error: Exception?) {
        error?.let { throw error }
    }

    // region PdMessenger

    private var messageSendingError: Exception? = null

    fun completeMessageSending(error: Exception) {
        messageSendingError = error
    }

    override fun sendFloat(message: FloatMessage) {
        receivedMessages.add(SendFloatCall(message))
        throwErrorIfNeeded(messageSendingError)
    }

    override fun sendBang(message: BangMessage) {
        receivedMessages.add(SendBangCall(message))
        throwErrorIfNeeded(messageSendingError)
    }

    override fun sendSymbol(message: SymbolMessage) {
        receivedMessages.add(SendSymbolCall(message))
        throwErrorIfNeeded(messageSendingError)
    }

    override fun sendList(message: ListMessage) {
        receivedMessages.add(SendListCall(message))
        throwErrorIfNeeded(messageSendingError)
    }

    override fun sendMessage(message: ArgumentMessage) {
        receivedMessages.add(SendMessageCall(message))
        throwErrorIfNeeded(messageSendingError)
    }

    // endregion
    // region PatchFileManager

    private var patchOpeningError: Exception? = null

    private var patches = mutableListOf<PatchFile>()

    override val openedPatches: List<PatchFile>
        get() = patches.toList()

    fun completePatchOpening(error: Exception) {
        patchOpeningError = error
    }

    override fun openPatch(file: PatchFile) {
        receivedMessages.add(OpenPatchCall(file))
        throwErrorIfNeeded(patchOpeningError)
        patches.add(file)
    }

    override fun closePatch(file: PatchFile) {
        receivedMessages.add(ClosePatchCall(file))
        patches.remove(file)
    }

    // endregion
    // region PdAudioManager

    private var playbackConfigError: Exception? = null

    fun completePlaybackConfiguration(error: Exception) {
        playbackConfigError = error
    }

    override fun startAudio() {
        receivedMessages.add(StartAudioCall)
    }

    override fun stopAudio() {
        receivedMessages.add(StopAudioCall)
    }

    override fun configurePlayback(configuration: PlaybackConfiguration) {
        receivedMessages.add(ConfigurePlaybackCall(configuration))
        throwErrorIfNeeded(playbackConfigError)
    }

    // endregion
}

sealed class ReceivedMessage
data class SendFloatCall(val message: FloatMessage) : ReceivedMessage()
data class SendBangCall(val message: BangMessage) : ReceivedMessage()
data class SendSymbolCall(val message: SymbolMessage) : ReceivedMessage()
data class SendListCall(val message: ListMessage) : ReceivedMessage()
data class SendMessageCall(val message: ArgumentMessage) : ReceivedMessage()
data class OpenPatchCall(val file: PatchFile) : ReceivedMessage()
data class ClosePatchCall(val file: PatchFile) : ReceivedMessage()
object StartAudioCall : ReceivedMessage()
object StopAudioCall : ReceivedMessage()
data class ConfigurePlaybackCall(val configuration: PlaybackConfiguration) : ReceivedMessage()
