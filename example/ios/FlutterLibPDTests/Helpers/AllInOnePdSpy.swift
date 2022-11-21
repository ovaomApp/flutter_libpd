//
//  PdMessengerSpy.swift
//  FlutterLibPDTests
//
//  Created by flav on 23/05/2022.
//

import Foundation
import flutter_libpd

class AllInOnePdSpy {
    
    enum ReceivedMessage: Equatable {
        case sendFloat(FloatMessage)
        case sendBang(BangMessage)
        case sendSymbol(SymbolMessage)
        case sendList(ListMessage)
        case sendMessage(ArgumentMessage)
        case openPatch(PatchFile)
        case closePatch(PatchFile)
        case startAudio
        case stopAudio
        case configurePlayback(PlaybackConfiguration)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private func throwErrorIfNeeded(error: Error?) throws {
        if let error = error {
            throw error
        }
    }
    
    // MARK: - PdMessenger Helper
    
    private var messageSendingError: Error?
    
    func completeMessageSending(with error: Error) {
        messageSendingError = error
    }
    
    // MARK: - PatchFileManager Helper

    private var patchOpeningError: Error?
    
    private var patches = [PatchFile]()
    
    func completePatchOpening(with error: Error) {
        patchOpeningError = error
    }
    
    // MARK: - PdAudioManager Helper

    private var playbackConfigError: Error?
    
    func completePlaybackConfiguration(with error: Error) {
        playbackConfigError = error
    }
}

// MARK: - PdMessenger

extension AllInOnePdSpy: PdMessenger {
    
    func sendFloat(_ message: FloatMessage) throws {
        receivedMessages.append(.sendFloat(message))
        try throwErrorIfNeeded(error: messageSendingError)
    }
    
    func sendBang(_ message: BangMessage) throws {
        receivedMessages.append(.sendBang(message))
        try throwErrorIfNeeded(error: messageSendingError)
    }
    
    func sendSymbol(_ message: SymbolMessage) throws {
        receivedMessages.append(.sendSymbol(message))
        try throwErrorIfNeeded(error: messageSendingError)
    }
    
    func sendList(_ message: ListMessage) throws {
        receivedMessages.append(.sendList(message))
        try throwErrorIfNeeded(error: messageSendingError)
    }
    
    func sendMessage(_ message: ArgumentMessage) throws {
        receivedMessages.append(.sendMessage(message))
        try throwErrorIfNeeded(error: messageSendingError)
    }
}

// MARK: - PatchFileManager

extension AllInOnePdSpy: PdPatchFileManager {
    var openedPatches: [PatchFile] {
        patches
    }
    
    func openPatch(_ file: PatchFile) throws {
        receivedMessages.append(.openPatch(file))
        try throwErrorIfNeeded(error: patchOpeningError)
        patches.append(file)
    }
    
    func closePatch(_ file: PatchFile) {
        receivedMessages.append(.closePatch(file))
        if let index = patches.firstIndex(of: file) {
            patches.remove(at: index)
        }
    }
}

// MARK: - PdAudioManager

extension AllInOnePdSpy: PdAudioManager {
    
    func startAudio() {
        receivedMessages.append(.startAudio)
    }
    
    func stopAudio() {
        receivedMessages.append(.stopAudio)
    }
    
    func configurePlayback(_ configuration: PlaybackConfiguration) throws {
        receivedMessages.append(.configurePlayback(configuration))
        try throwErrorIfNeeded(error: playbackConfigError)
    }
}
