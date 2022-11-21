//
//  ReveiveMessageStreamerHandlerTests.swift
//  FlutterLibPDTests
//
//  Created by flav on 01/06/2022.
//

import XCTest
import flutter_libpd

class ReveiveMessageStreamHandlerTests: SetupPdEnvironmentXCTestCase {
    
    func testOnListenWithWrongParamsFailsOnError() {
        let sut = makeSUT()
        
        assertOnListenDeliversError(sut, arguments: nil)
        assertOnListenDeliversError(sut, arguments: [])
        assertOnListenDeliversError(sut, arguments: [2])
        assertOnListenDeliversError(sut, arguments: ["d", "d"])
        assertOnListenDeliversError(sut, arguments: [""])
    }
    
    func testOnListenWithWrongParamsDoesNotCallEventCallback() {
        let sut = makeSUT()
        let expectation = makeInvertedExpectation(description: "onListen eventCallback must not be called")
        
        _ = sut.onListen(withArguments: nil) { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testOnListenObservesEvents() throws {
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "eventCallback must be called")
        let message = anyBaseMessage(anyReceiver())

        var result: [String: Any?]?
        _ = sut.onListen(withArguments: [message.receiver]) { event in
            result = event as? [String: Any?]
            expectation.fulfill()
        }
        try pdController.sendMessage(message)
    
        wait(for: [expectation], timeout: timeout)
        XCTAssertNotNil(result)
        assertEqual(result!, makeExpectedEvent(message))
    }
    
    func testOnCancelWithWrongParamsFailsOnError() {
        let sut = makeSUT()
        
        assertOnCancelDeliversError(sut, arguments: nil)
        assertOnCancelDeliversError(sut, arguments: [])
        assertOnCancelDeliversError(sut, arguments: [2])
        assertOnCancelDeliversError(sut, arguments: ["d", "d"])
        assertOnCancelDeliversError(sut, arguments: [""])
    }
    
    func testOnCancelDoesNotObserveEvents() throws {
        let sut = makeSUT()
        let expectation = makeInvertedExpectation(description: "eventCallback must not be called")
        let message = anyBaseMessage(realReceiver())

        _ = sut.onListen(withArguments: [message.receiver]) { event in
            expectation.fulfill()
        }
        
        _ = sut.onCancel(withArguments: [message.receiver])
        
        try pdController.sendMessage(message)
    
        wait(for: [expectation], timeout: timeout)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ReceiveMessageStreamHandler {
        let messageReceiver = PdMessageReceiverImpl()
        let sut = ReceiveMessageStreamHandler(messageReceiver: messageReceiver)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(messageReceiver, file: file, line: line)
        addTeardownBlock { [weak messageReceiver] in
            messageReceiver?.dispose()
        }
        return sut
    }
    
    private func assertOnCancelDeliversError(_ sut: ReceiveMessageStreamHandler, arguments: Any?, file: StaticString = #filePath, line: UInt = #line) {
        let error = sut.onCancel(withArguments: arguments)
        XCTAssertNotNil(error, "onCancel with invalid args must returns an error", file: file, line: line)
    }
    
    private func assertOnListenDeliversError(_ sut: ReceiveMessageStreamHandler, arguments: Any?, file: StaticString = #filePath, line: UInt = #line) {
        let error = sut.onListen(withArguments: arguments) { _ in }
        XCTAssertNotNil(error, "onListen with invalid args must returns an error", file: file, line: line)
    }
    
    private func assertEqual(_ result: [String: Any?], _ expectedEvent: [String: Any?], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(result.keys, expectedEvent.keys, file: file, line: line)
        XCTAssertEqual(result[sourceKey] as? String, expectedEvent[sourceKey] as? String, file: file, line: line)
        XCTAssertEqual(result[symbolKey] as? String, expectedEvent[symbolKey] as? String, file: file, line: line)
        XCTAssertTrue(Array.isEqualTo(lhs: result[valueKey] as? [Any], rhs: expectedEvent[valueKey] as? [Any]), file: file, line: line)
    }
    
    private func makeExpectedEvent(_ message: ArgumentMessage) -> [String: Any?] {
        [sourceKey : message.receiver,
         symbolKey : message.value,
          valueKey : message.arguments]
    }
    
    private let sourceKey = "source"
    private let symbolKey = "symbol"
    private let valueKey = "value"
}
