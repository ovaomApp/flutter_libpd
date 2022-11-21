//
//  FlutterLibPDTests.swift
//  FlutterLibPDTests
//
//  Created by flav on 23/05/2022.
//

import XCTest
import flutter_libpd

class SwiftFlutterLibpdPluginTests: XCTestCase {
    
    func testXMethodWithWrongParamsFailsOnError() {
        let sut = makeSUT()
        
        expectMethodFailsWithWrongParams(methodName: openPatchMethodName, sut: sut)
        expectMethodFailsWithWrongParams(methodName: closePatchMethodName, sut: sut)
        expectMethodFailsWithWrongParams(methodName: sendFloatMethodName, sut: sut)
        expectMethodFailsWithWrongParams(methodName: sendBangMethodName, sut: sut)
        expectMethodFailsWithWrongParams(methodName: sendSymbolMethodName, sut: sut)
        expectMethodFailsWithWrongParams(methodName: sendListMethodName, sut: sut)
        expectMethodFailsWithWrongParams(methodName: sendMessageMethodName, sut: sut)
        expectMethodFailsWithWrongParams(methodName: configurePlaybackMethodName, sut: sut)
        expectMethodFailsWithWrongParams(methodName: getAbsolutePathMethodName, sut: sut)
    }
    
    func testOpenPatchOpensPatchSuccessfully() {
        let sut = makeSUT()
        
        expect(assertion:
                { error in XCTAssertNil(error) },
               when: openPatchCall(patchFile: anyPatchFile()),
               sut: sut)
    }
    
    func testOpenPatchWithInvalidPatchFailsOnError() {
        let sut = makeSUT()
        
        expect(assertion:
                { error in XCTAssertNotNil(error) },
               when: openPatchCall(patchFile: PatchFile(name: "", path: "")),
               sut: sut)
    }
    
    
    func testClosePatchRequestsPatchClosing() {
        let sut = makeSUT()
        
        expect(assertion:
                { error in XCTAssertNil(error) },
               when: closePatchCall(patchFile: anyPatchFile()),
               sut: sut)
    }
    
    func testGetAbsolutePathTriesToDeliverPath() {
        let sut = makeSUT()

        XCTAssertEqual(getAbsolutePath(sut, anyPatchFile().name), anyPatchFile().fullPath)
        XCTAssertNil(getAbsolutePath(sut, "invalid"))
    }
    
    
    func testSendXMessageWithoutPatchOpeningFailsOnError() {
        let sut = makeSUT()
        
        expectSendAllMessages(sut: sut) { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testSendXMessageSendsMessageSuccessfully() {
        let sut = makeSUT()
        openPatch(sut: sut)
        
        expectSendAllMessages(sut: sut) { error in
            XCTAssertNil(error)
        }
    }
    
    func testConfigurePlaybackConfiguresAudio() {
        let sut = makeSUT()
        
        expect(assertion:
                { error in XCTAssertNil(error) },
               when: configurePlaybackCall(),
               sut: sut)
    }
    
    func testConfigurePlaybackWithInvalidConfigFailsOnError() {
        let sut = makeSUT()
        let invalidConfig: [String: Any] = [
            "inputEnabled": false,
            "outputNumberOfChannels": -1
        ]
        
        expect(assertion:
                { error in XCTAssertNotNil(error) },
               when: configurePlaybackCall(invalidConfig),
               sut: sut)
    }
    
    func testToggleAudioStateRequestsStateChanging() {
        let sut = makeSUT()
        
        expect(assertion:
                { error in XCTAssertNil(error) },
               when: startAudioCall(),
               sut: sut)
        
        expect(assertion:
                { error in XCTAssertNil(error) },
               when: stopAudioCall(),
               sut: sut)
    }
    
    func testDisposeRequestsStatesCleaning() {
        let sut = makeSUT()
        
        expect(assertion:
                { error in XCTAssertNil(error) },
               when: disposeCall(),
               sut: sut)
    }
        
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SwiftFlutterLibpdPlugin {
        let sut = SwiftFlutterLibpdPlugin(bundle: testBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expectSendAllMessages(sut: SwiftFlutterLibpdPlugin, assertion: (FlutterError?) -> Void) {
        expect(assertion: assertion,
               when: sendFloatCall(),
               sut: sut)
        
        expect(assertion: assertion,
               when: sendBangCall(),
               sut: sut)
        
        expect(assertion: assertion,
               when: sendSymbolCall(),
               sut: sut)
        
        expect(assertion: assertion,
               when: sendListCall(),
               sut: sut)
        
        expect(assertion: assertion,
               when: sendMessageCall(),
               sut: sut)
    }
    
    private func expectMethodFailsWithWrongParams(methodName: String, sut: SwiftFlutterLibpdPlugin, file: StaticString = #filePath, line: UInt = #line) {
        let call = FlutterMethodCall(methodName: methodName, arguments: nil)
        
        expect(assertion: { error in
            XCTAssertNotNil(error, "\(methodName) must return an error", file: file, line: line)
        }, when: call, sut: sut)
    }
    
    private func expect(assertion: (FlutterError?) -> Void, when call: FlutterMethodCall, sut: SwiftFlutterLibpdPlugin) {
        let expectation = XCTestExpectation()
        var error: FlutterError?
        
        sut.handle(call) { result in
            error = result as? FlutterError
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        assertion(error)
    }
    
    private func getAbsolutePath(_ sut: SwiftFlutterLibpdPlugin, _ filename: String) -> String? {
        let expectation = XCTestExpectation()

        var path: String?
        sut.handle(getAbsolutePathCall(filename: filename)) { result in
            path = result as? String
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        return path
    }
    
    private func openPatch(sut: SwiftFlutterLibpdPlugin) {
        sut.handle(openPatchCall(patchFile: anyPatchFile())) { _ in }
        
        addTeardownBlock { [unowned self, weak sut] in
            sut?.handle(self.closePatchCall(patchFile: anyPatchFile())) { _ in }
        }
    }
    
    private func patchCall(methodName: String, patchFile: PatchFile) -> FlutterMethodCall {
        FlutterMethodCall(methodName: methodName, arguments: ["patchName": patchFile.name, "path": patchFile.path])
    }
    
    private func openPatchCall(patchFile: PatchFile) -> FlutterMethodCall {
        patchCall(methodName: openPatchMethodName, patchFile: patchFile)
    }
    
    private func closePatchCall(patchFile: PatchFile) -> FlutterMethodCall {
        patchCall(methodName: closePatchMethodName, patchFile: patchFile)
    }
    
    private func getAbsolutePathCall(filename: String) -> FlutterMethodCall {
        FlutterMethodCall(methodName: getAbsolutePathMethodName, arguments: filename)
    }
    
    private func configurePlaybackCall(_ arguments: [String: Any]? = nil) -> FlutterMethodCall {
        FlutterMethodCall(methodName: configurePlaybackMethodName, arguments: arguments ?? ["inputEnabled": true])
    }
    
    private func startAudioCall() -> FlutterMethodCall {
        FlutterMethodCall(methodName: "startAudio", arguments: nil)
    }
    
    private func stopAudioCall() -> FlutterMethodCall {
        FlutterMethodCall(methodName: "stopAudio", arguments: nil)
    }
    
    private func disposeCall() -> FlutterMethodCall {
        FlutterMethodCall(methodName: "dispose", arguments: nil)
    }
    
    private func sendFloatCall() -> FlutterMethodCall {
        FlutterMethodCall(methodName: sendFloatMethodName, arguments: ["value": Double(anyFloatValue()), receiverKey: realReceiver()])
    }
    
    private func sendBangCall() -> FlutterMethodCall {
        FlutterMethodCall(methodName: sendBangMethodName, arguments: realReceiver())
    }
    
    private func sendSymbolCall() -> FlutterMethodCall {
        FlutterMethodCall(methodName: sendSymbolMethodName, arguments: ["symbol": anyStringValue(), receiverKey: realReceiver()])
    }
    
    private func sendListCall() -> FlutterMethodCall {
        FlutterMethodCall(methodName: sendListMethodName, arguments: ["list": [anyStringValue(), anyFloatValue()], receiverKey: realReceiver()])
    }
    
    private func sendMessageCall() -> FlutterMethodCall {
        FlutterMethodCall(methodName: sendMessageMethodName, arguments: [
            "message": anyStringValue(),
            "arguments": [anyStringValue(), anyFloatValue()],
            receiverKey: realReceiver()])
    }

    private let receiverKey = "receiver"

    private let openPatchMethodName = "openPatch"
    private let closePatchMethodName = "closePatch"
    private let sendFloatMethodName = "sendFloat"
    private let sendBangMethodName = "sendBang"
    private let sendSymbolMethodName = "sendSymbol"
    private let sendListMethodName = "sendList"
    private let sendMessageMethodName = "sendMessage"
    private let configurePlaybackMethodName = "configurePlayback"
    private let getAbsolutePathMethodName = "getAbsolutePath"
}
