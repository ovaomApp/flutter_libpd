//
//  PdAudioManagerImpl.swift
//  Runner
//
//  Created by flav on 25/05/2022.
//

import Foundation
import libpd_ios
import AVFAudio

public class PdAudioManagerImpl: PdAudioManager {
    
    private let audioController: PdAudioController
    
    public init(audioController: PdAudioController = PdAudioController()) {
        self.audioController = audioController
    }

    // workaround: https://github.com/libpd/libpd/issues/249
    private func setAudioProfileToPairBLEDevice() {
        audioController.allowBluetoothA2DP = true
        audioController.mode = AVAudioSession.Mode.videoRecording.rawValue as NSString
    }
    
    private func setDefaultAudioProfile() {
        audioController.allowBluetoothA2DP = false
        audioController.mode = AVAudioSession.Mode.default.rawValue as NSString
    }
    
    private func setAudioProfile(_ configuration: PlaybackConfiguration) {
        if configuration.inputEnabled {
            setAudioProfileToPairBLEDevice()
        } else {
            setDefaultAudioProfile()
        }
    }
    
    public func configurePlayback(_ configuration: PlaybackConfiguration) throws {
        setAudioProfile(configuration)
        
        let audioStatus = audioController.configurePlayback(withSampleRate: configuration.sampleRate.int32Value,
                                                            numberChannels: (configuration.inputNumberOfChannels + configuration.outputNumberOfChannels).int32Value,
                                                            inputEnabled: configuration.inputEnabled,
                                                            mixingEnabled: false)
        
        if audioStatus == PdAudioError {
            throw AudioError.configurationFailed
        }
    }
    
    public func startAudio() {
        audioController.isActive = true
    }
    
    public func stopAudio() {
        audioController.isActive = false
    }
}

extension Int {
    var int32Value: Int32 { Int32(self) }
}

