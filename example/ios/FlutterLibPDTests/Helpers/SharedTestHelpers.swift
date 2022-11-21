//
//  shared_test_helpers.swift
//  FlutterLibPDTests
//
//  Created by flav on 25/05/2022.
//

import flutter_libpd
import XCTest

extension XCTestCase {
    var timeout: TimeInterval { 0.1 }

    var testBundle: Bundle {
        Bundle(for: type(of: self))
    }
    
    func anyPatchFile(_ patchName: String = "main.pd") -> PatchFile {
        PatchFile(name: patchName, path: getPath(forPatch: patchName, in: testBundle) + "/")
    }

    private func getPath(forPatch name: String, in bundle: Bundle) -> String {
        let splittedName = name.split(separator: ".")
        let path = bundle.path(forResource: "\(splittedName[0])", ofType: "\(splittedName[1])")!
        var url = URL(fileURLWithPath: path)
        url.deleteLastPathComponent()
        return url.path
    }
    
    func anyStringValue() -> String {
        "anyString"
    }
    
    func anyFloatValue() -> Float {
        0.5
    }
    
    func anyReceiver() -> String {
        "anyReceiver"
    }
    
    func anyFloatMessage(_ receiver: String? = nil) -> FloatMessage {
        FloatMessage(value: anyFloatValue(), receiver: receiver ?? anyReceiver())
    }
    
    func anyBangMessage(_ receiver: String? = nil) -> BangMessage {
        BangMessage(receiver: receiver ?? anyReceiver())
    }
    
    func anySymbolMessage(_ receiver: String? = nil) -> SymbolMessage {
        SymbolMessage(value: anyStringValue(), receiver: receiver ?? anyReceiver())
    }
    
    func anyListMessage(_ receiver: String? = nil) -> ListMessage {
        ListMessage(value: [anyFloatValue(), anyStringValue()], receiver: receiver ?? anyReceiver())
    }
    
    func anyBaseMessage(_ receiver: String? = nil) -> ArgumentMessage {
        ArgumentMessage(value: anyStringValue(), arguments: [anyStringValue(), anyFloatValue()], receiver: receiver ?? anyReceiver())
    }
    
    func anyPlaybackConfiguration(inputEnabled: Bool = false) -> PlaybackConfiguration {
        PlaybackConfiguration(sampleRate: 44100,
                              inputNumberOfChannels: 1,
                              outputNumberOfChannels: 1,
                              inputEnabled: inputEnabled)
    }
    
    func makeInvertedExpectation(description: String? = nil) -> XCTestExpectation {
        let expectation = XCTestExpectation(description: description ?? "")
        expectation.isInverted = true
        return expectation
    }
    
    func realReceiver() -> String {
        "pd-gameSlot"
    }
}

