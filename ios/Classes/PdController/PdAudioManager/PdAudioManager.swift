//
//  PdAudioManager.swift
//  Runner
//
//  Created by flav on 24/05/2022.
//

import Foundation

public protocol PdAudioManager {
    func startAudio()
    func stopAudio()
    func configurePlayback(_ configuration: PlaybackConfiguration) throws
}

public struct PlaybackConfiguration {
    public let sampleRate: Int
    public let inputNumberOfChannels: Int
    public let outputNumberOfChannels: Int
    public let inputEnabled: Bool
    
    public init(sampleRate: Int,
    inputNumberOfChannels: Int,
    outputNumberOfChannels: Int,
    inputEnabled: Bool) {
         self.sampleRate = sampleRate
         self.inputNumberOfChannels = inputNumberOfChannels
         self.outputNumberOfChannels = outputNumberOfChannels
         self.inputEnabled = inputEnabled
    }
}

public enum AudioError: Error {
    case configurationFailed
}
