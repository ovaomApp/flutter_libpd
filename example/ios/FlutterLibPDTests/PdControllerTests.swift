//
//  PdControllerTests.swift
//  FlutterLibPDTests
//
//  Created by flav on 23/05/2022.
//

import XCTest
import flutter_libpd

class PdControllerTests: XCTestCase {
    
    func testSendXRequestsXMessage() throws {
        let (sut, pdSpy) = makeSUT()
        
        try sut.sendFloat(anyFloatMessage())
        XCTAssertEqual(pdSpy.receivedMessages[0], .sendFloat(anyFloatMessage()))
        XCTAssertEqual(pdSpy.receivedMessages.count, 1)

        try sut.sendBang(anyBangMessage())
        XCTAssertEqual(pdSpy.receivedMessages[1], .sendBang(anyBangMessage()))
        XCTAssertEqual(pdSpy.receivedMessages.count, 2)
        
        try sut.sendSymbol(anySymbolMessage())
        XCTAssertEqual(pdSpy.receivedMessages[2], .sendSymbol(anySymbolMessage()))
        XCTAssertEqual(pdSpy.receivedMessages.count, 3)
        
        try sut.sendList(anyListMessage())
        XCTAssertEqual(pdSpy.receivedMessages[3], .sendList(anyListMessage()))
        XCTAssertEqual(pdSpy.receivedMessages.count, 4)
        
        try sut.sendMessage(anyBaseMessage())
        XCTAssertEqual(pdSpy.receivedMessages[4], .sendMessage(anyBaseMessage()))
        XCTAssertEqual(pdSpy.receivedMessages.count, 5)
    }
    
    func testSendXFailsOnSendingError() {
        let (sut, pdSpy) = makeSUT()
        pdSpy.completeMessageSending(with: anyNSError())
        
        XCTAssertThrowsError(try sut.sendFloat(anyFloatMessage()))
        XCTAssertThrowsError(try sut.sendBang(anyBangMessage()))
        XCTAssertThrowsError(try sut.sendSymbol(anySymbolMessage()))
        XCTAssertThrowsError(try sut.sendList(anyListMessage()))
        XCTAssertThrowsError(try sut.sendMessage(anyBaseMessage()))
    }
    
    func testOpenPatchRequestsPatchOpening() throws {
        let (sut, pdSpy) = makeSUT()
        
        try sut.openPatch(anyPatchFile())
        
        XCTAssertEqual(pdSpy.receivedMessages, [.openPatch(anyPatchFile())])
    }
    
    func testOpenPatchFailsOnPatchOpeningError() {
        let (sut, pdSpy) = makeSUT()
        
        pdSpy.completePatchOpening(with: anyNSError())
        
        XCTAssertThrowsError(try sut.openPatch(anyPatchFile()))
    }
    
    func testClosePatchRequestsPatchClosing() throws {
        let (sut, pdSpy) = makeSUT()
        let patchFile = anyPatchFile()
        try sut.openPatch(patchFile)
        
        sut.closePatch(patchFile)
        
        XCTAssertEqual(pdSpy.receivedMessages, [
            .openPatch(patchFile),
            .closePatch(patchFile)
        ])
    }
    
    func testStartAudioRequestsAudioStatusChanging() {
        let (sut, pdSpy) = makeSUT()
        
        sut.startAudio()
        
        XCTAssertEqual(pdSpy.receivedMessages, [.startAudio])
    }
    
    func testStopAudioRequestsAudioStatusChanging() {
        let (sut, pdSpy) = makeSUT()
        
        sut.stopAudio()
        
        XCTAssertEqual(pdSpy.receivedMessages, [.stopAudio])
    }
    
    func testConfigurePlaybackRequestsPlaybackConfiguration() throws {
        let (sut, pdSpy) = makeSUT()

       try sut.configurePlayback(anyPlaybackConfiguration())

        XCTAssertEqual(pdSpy.receivedMessages,
                       [.configurePlayback(anyPlaybackConfiguration())])
    }
    
    func testConfigurePlaybackFailsOnPlaybackConfigurationError() {
        let (sut, pdSpy) = makeSUT()
        
        pdSpy.completePlaybackConfiguration(with: anyNSError())
        
        XCTAssertThrowsError(try         sut.configurePlayback(anyPlaybackConfiguration()))
    }
    
    func testDisposeCleansUpInternalStates() throws {
        let (sut, pdSpy) = makeSUT()
        try sut.openPatch(anyPatchFile())
        
        sut.dispose()
        
        XCTAssertEqual(Array(pdSpy.receivedMessages.dropFirst()),
                       [.stopAudio, .closePatch(anyPatchFile())])
    }
    
    func testDisposeTwiceCleansUpPatchesOnce() throws {
        let (sut, pdSpy) = makeSUT()
        try sut.openPatch(anyPatchFile())
        
        sut.dispose()
        sut.dispose()
        
        XCTAssertEqual(Array(pdSpy.receivedMessages.dropFirst()),
                       [.stopAudio, .closePatch(anyPatchFile()), .stopAudio])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: PdController, pdSpy: AllInOnePdSpy) {
        let pdSpy = AllInOnePdSpy()
        let sut = PdController(messenger: pdSpy,
                               patchManager: pdSpy,
                               audioManager:  pdSpy)
        trackForMemoryLeaks(pdSpy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, pdSpy)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}
