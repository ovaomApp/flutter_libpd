//
//  PdMessengerImpl.swift
//  FlutterLibPDTests
//
//  Created by flav on 25/05/2022.
//

import XCTest
import flutter_libpd

class PdMessengerImplTests: XCTestCase {
    var patchManager: PdPatchFileManagerImpl!
    
    override func setUp() {
        setupPatchManagerState()
    }
    
    override func tearDown() {
        undoPatchManagerSideEffects()
    }
    
    func testSendXMessageSendsMessageSuccessfully() throws {
        let sut = makeSUT()
        let receiver = realReceiver()
        
        XCTAssertNoThrow(try sut.sendFloat(anyFloatMessage(receiver)))
        XCTAssertNoThrow(try sut.sendBang(anyBangMessage(receiver)))
        XCTAssertNoThrow(try sut.sendSymbol(anySymbolMessage(receiver)))
        XCTAssertNoThrow(try sut.sendList(anyListMessage(receiver)))
        XCTAssertNoThrow(try sut.sendMessage(anyBaseMessage(receiver)))
    }
    
    func testSendXMessageFailsOnError() throws {
        let sut = makeSUT()
        let invalidReceiver = "InvalidReceiver"
        
        XCTAssertThrowsError(try sut.sendFloat(anyFloatMessage(invalidReceiver)))
        XCTAssertThrowsError(try sut.sendBang(anyBangMessage(invalidReceiver)))
        XCTAssertThrowsError(try sut.sendSymbol(anySymbolMessage(invalidReceiver)))
        XCTAssertThrowsError(try sut.sendList(anyListMessage(invalidReceiver)))
        XCTAssertThrowsError(try sut.sendMessage(anyBaseMessage(invalidReceiver)))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> PdMessenger {
        let sut = PdMessengerImpl()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func setupPatchManagerState() {
        patchManager = PdPatchFileManagerImpl()
        try? patchManager.openPatch(anyPatchFile())
    }
    
    private func undoPatchManagerSideEffects() {
        patchManager.closePatch(anyPatchFile())
        patchManager = nil
    }
}

