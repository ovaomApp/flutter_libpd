//
//  PdController.swift
//  Runner
//
//  Created by flav on 23/05/2022.
//

import Foundation

public class PdController {
    private let messenger: PdMessenger
    private let patchManager: PdPatchFileManager
    private let audioManager: PdAudioManager
    
    public init(messenger: PdMessenger = PdMessengerImpl(),
                patchManager: PdPatchFileManager = PdPatchFileManagerImpl(),
                audioManager: PdAudioManager = PdAudioManagerImpl()) {
        self.messenger = messenger
        self.patchManager = patchManager
        self.audioManager = audioManager
    }
    
    public func sendFloat(_ message: FloatMessage) throws {
        try messenger.sendFloat(message)
    }
    
    public func sendBang(_ message: BangMessage) throws {
        try messenger.sendBang(message)
    }
    
    public func sendSymbol(_ message: SymbolMessage) throws {
        try messenger.sendSymbol(message)
    }
    
    public func sendList(_ message: ListMessage) throws {
        try messenger.sendList(message)
    }

    public func sendMessage(_ message: ArgumentMessage) throws {
        try messenger.sendMessage(message)
    }
    
    public func openPatch(_ file: PatchFile) throws {
        try patchManager.openPatch(file)
    }
    
    public func closePatch(_ file: PatchFile) {
        patchManager.closePatch(file)
    }
    
    public func startAudio() {
        audioManager.startAudio()
    }
    
    public func stopAudio() {
        audioManager.stopAudio()
    }
    
    public func configurePlayback(_ configuration: PlaybackConfiguration) throws {
        try audioManager.configurePlayback(configuration)
    }
    
    public func dispose() {
        stopAudio()
        patchManager.openedPatches.forEach { closePatch($0) }
    }
}
