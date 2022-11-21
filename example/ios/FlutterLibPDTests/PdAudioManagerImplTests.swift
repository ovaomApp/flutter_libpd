//
//  PdAudioManagerTest.swift
//  FlutterLibPDTests
//
//  Created by flav on 25/05/2022.
//

import XCTest
import libpd_ios
import flutter_libpd

class PdAudioManagerImplTests: XCTestCase {
    
    func testConfigurePlaybackConfiguresAudioSuccessfully() {
        let (sut, audioController) = makeSUT()
        let config = anyPlaybackConfiguration()
        
        XCTAssertNoThrow(try sut.configurePlayback(config))
        
        XCTAssertEqual(Int(audioController.sampleRate), config.sampleRate)
        XCTAssertEqual(audioController.inputEnabled, config.inputEnabled)
        XCTAssertEqual(audioController.inputChannels.intValue, config.inputNumberOfChannels)
        XCTAssertEqual(audioController.outputChannels.intValue, config.outputNumberOfChannels)
    }
    
    func testConfigurePlaybackFailsOnError() {
        let (sut, _) = makeSUT()
        let invalidConfig = PlaybackConfiguration(sampleRate: -44100,
                                                  inputNumberOfChannels: -1,
                                                  outputNumberOfChannels: -1,
                                                  inputEnabled: false)
        
        XCTAssertThrowsError(try sut.configurePlayback(invalidConfig))
    }

    func testConfigurePlaybackWithoutInputEnabledConfiguresAudioProfileToPairBLEDevice() throws {
        let (sut, audioController) = makeSUT()
        let config = anyPlaybackConfiguration(inputEnabled: false)
    
        try sut.configurePlayback(config)
        
        XCTAssertFalse(audioController.allowBluetoothA2DP)
        XCTAssertEqual(audioController.mode, AVAudioSession.Mode.default.rawValue as NSString)
    }
    
    func testConfigurePlaybackWithInputEnabledConfiguresAudioProfileToPairBLEDevice() throws {
        let (sut, audioController) = makeSUT()
        let config = anyPlaybackConfiguration(inputEnabled: true)
    
        try sut.configurePlayback(config)
        
        XCTAssertTrue(audioController.allowBluetoothA2DP)
        XCTAssertEqual(audioController.mode, AVAudioSession.Mode.videoRecording.rawValue as NSString)
    }
    
    
    func testAudioActivationChangesAudioState() throws {
        let (sut, audioController) = makeSUT()
        
        expectAudioState(sut, audioController, onStart: false, onStop: false, "Without configuration ")
        
        try sut.configurePlayback(anyPlaybackConfiguration())
        expectAudioState(sut, audioController, onStart: true, onStop: false, "After configuration ")
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: PdAudioManager, audioController: PdAudioController) {
        let audioController = PdAudioController()!
        let sut = PdAudioManagerImpl(audioController: audioController)
        trackForMemoryLeaks(audioController, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, audioController)
    }
    
    private func expectAudioState(_ sut: PdAudioManager, _ audioController: PdAudioController, onStart: Bool, onStop: Bool, _ extratMessage: String = "", file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(audioController.isActive, false, "\(extratMessage)by default audio state is disabled", file: file, line: line)
        
        sut.startAudio()
        XCTAssertEqual(audioController.isActive, onStart, "\(extratMessage)When startAudio the audio state should be \(onStart)", file: file, line: line)
        
        sut.stopAudio()
        XCTAssertEqual(audioController.isActive, onStop, "\(extratMessage)When stopAudio the audio state should be \(onStop)", file: file, line: line)
    }
}

extension Int32 {
    var intValue: Int { Int(self) }
}
