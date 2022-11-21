package com.ovaom.flutter_libpd_example

import com.ovaom.flutter_libpd.pd_controller.PdController
import com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager.PatchFile
import com.ovaom.flutter_libpd_example.helpers_test.*
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import kotlin.Exception

class PdControllerTest {

    @Test
    fun testSendXRequestsXMessage() {
        val (sut, pdSpy) = makeSUT()

        sut.sendFloat(anyFloatMessage())
        assertEquals(SendFloatCall(anyFloatMessage()), pdSpy.receivedMessages[0])
        assertEquals(1, pdSpy.receivedMessages.size)

        sut.sendBang(anyBangMessage())
        assertEquals(SendBangCall(anyBangMessage()), pdSpy.receivedMessages[1])
        assertEquals(2, pdSpy.receivedMessages.size)

        sut.sendSymbol(anySymbolMessage())
        assertEquals(SendSymbolCall(anySymbolMessage()), pdSpy.receivedMessages[2])
        assertEquals(3, pdSpy.receivedMessages.size)

        sut.sendList(anyListMessage())
        assertEquals(SendListCall(anyListMessage()), pdSpy.receivedMessages[3])
        assertEquals(4, pdSpy.receivedMessages.size)

        sut.sendMessage(anyBaseMessage())
        assertEquals(SendMessageCall(anyBaseMessage()), pdSpy.receivedMessages[4])
        assertEquals(5, pdSpy.receivedMessages.size)
    }

    @Test
    fun testSendXFailsOnSendingError() {
        val (sut, pdSpy) = makeSUT()
        pdSpy.completeMessageSending(anyError())

        assertThrows<Exception> { sut.sendFloat(anyFloatMessage()) }
        assertThrows<Exception> { sut.sendBang(anyBangMessage()) }
        assertThrows<Exception> { sut.sendSymbol(anySymbolMessage()) }
        assertThrows<Exception> { sut.sendList(anyListMessage()) }
        assertThrows<Exception> { sut.sendMessage(anyBaseMessage()) }
    }

    @Test
    fun testOpenPatchRequestsPatchOpening() {
        val (sut, pdSpy) = makeSUT()

        sut.openPatch(anyPatchFile())

        assertEquals(listOf<ReceivedMessage>(OpenPatchCall(anyPatchFile())), pdSpy.receivedMessages)
    }

    @Test
    fun testOpenPatchFailsOnPatchOpeningError() {
        val (sut, pdSpy) = makeSUT()

        pdSpy.completePatchOpening(anyError())

        assertThrows<Exception> { sut.openPatch(anyPatchFile()) }
    }

    @Test
    fun testClosePatchRequestsPatchClosing() {
        val (sut, pdSpy) = makeSUT()
        val patchFile = anyPatchFile()
        sut.openPatch(patchFile)

        sut.closePatch(patchFile)

        assertEquals(listOf(OpenPatchCall(patchFile), ClosePatchCall(patchFile)),
                pdSpy.receivedMessages)
    }

    @Test
    fun testStartAudioRequestsAudioStatusChanging() {
        val (sut, pdSpy) = makeSUT()

        sut.startAudio()

        assertEquals(listOf<ReceivedMessage>(StartAudioCall), pdSpy.receivedMessages)
    }

    @Test
    fun testStopAudioRequestsAudioStatusChanging() {
        val (sut, pdSpy) = makeSUT()

        sut.stopAudio()

        assertEquals(listOf<ReceivedMessage>(StopAudioCall), pdSpy.receivedMessages)
    }

    @Test
    fun testConfigurePlaybackRequestsPlaybackConfiguration() {
        val (sut, pdSpy) = makeSUT()

        sut.configurePlayback(anyPlaybackConfiguration())

        assertEquals(listOf<ReceivedMessage>(ConfigurePlaybackCall(anyPlaybackConfiguration())), pdSpy.receivedMessages)
    }

    @Test
    fun testConfigurePlaybackFailsOnPlaybackConfigurationError() {
        val (sut, pdSpy) = makeSUT()

        pdSpy.completePlaybackConfiguration(anyError())

        assertThrows<Exception> { sut.configurePlayback(anyPlaybackConfiguration()) }
    }

    @Test
    fun testDisposeCleansUpInternalStates() {
        val (sut, pdSpy) = makeSUT()
        sut.openPatch(anyPatchFile())

        sut.dispose()

        assertEquals(listOf(StopAudioCall, ClosePatchCall(anyPatchFile())), pdSpy.receivedMessages.drop(1))
    }

    @Test
    fun testDisposeTwiceCleansUpPatchesOnce() {
        val (sut, pdSpy) = makeSUT()
        sut.openPatch(anyPatchFile())

        sut.dispose()
        sut.dispose()

        assertEquals(listOf(StopAudioCall, ClosePatchCall(anyPatchFile()), StopAudioCall),
                pdSpy.receivedMessages.drop(1))
    }
}

// Helpers

private fun makeSUT(): Pair<PdController, AllInOnePdSpy> {
    val pdSpy = AllInOnePdSpy()
    val sut = PdController(pdSpy, pdSpy, pdSpy)
    return Pair(sut, pdSpy)
}

private fun anyError(): Exception {
    return Exception()
}

private fun anyPatchFile(patchName: String = "main.pd"): PatchFile {
    return PatchFile(patchName, "anyPath")
}