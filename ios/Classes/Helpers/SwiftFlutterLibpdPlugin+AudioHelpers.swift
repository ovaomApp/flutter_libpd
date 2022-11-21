//
//  SwiftFlutterLibpdPlugin+AudioHelpers.swift
//  flutter_libpd
//
//  Created by flav on 30/05/2022.
//

import AVFAudio

// MARK: - Audio Extension Helper

extension SwiftFlutterLibpdPlugin {
    // MARK: - Start Audio
    
    public func startAudio(_ result: @escaping FlutterResult) {
        pdController.startAudio()
        result(nil)
    }
    
    // MARK: - Stop Audio
    
    public func stopAudio(_ result: @escaping FlutterResult) {
        pdController.stopAudio()
        result(nil)
    }
    
    // MARK: - Configure Playback
    
    public func configurePlayback(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let json = arguments as? [String: Any],
              let configuration = PlaybackConfiguration(fromJson: json, audioSession: AVAudioSession.sharedInstance()) else {
                  return result(FlutterError(code: "INVALID_PARAMETERS", message: "Expected parameters: [(required) 'inputEnabled': Bool, (optional) 'sampleRate': Int, (optional) 'inputNumberOfChannels': Int, (optional) 'outputNumberOfChannels': Int]", details: arguments))
              }
        
        
        do {
            try pdController.configurePlayback(configuration)
            result(nil)
        } catch {
            result(FlutterError(code: "CONFIGURE_PLAYBACK_FAILED", message: "unable to configure playback", details: arguments))
        }
    }
}

extension PlaybackConfiguration {
    init?(fromJson json: [String: Any], audioSession: AVAudioSession) {
        guard let inputEnabled = json["inputEnabled"] as? Bool else {
            return nil
        }
        
        let sampleRate = json["sampleRate"] as? Int ?? Int(audioSession.sampleRate)
        let inputNumberOfChannels = json["inputNumberOfChannels"] as? Int ?? audioSession.inputNumberOfChannels
        let outputNumberOfChannels = json["outputNumberOfChannels"] as? Int ?? audioSession.outputNumberOfChannels
        self.init(sampleRate: sampleRate,
                  inputNumberOfChannels: inputNumberOfChannels,
                  outputNumberOfChannels: outputNumberOfChannels,
                  inputEnabled: inputEnabled)
    }
}
