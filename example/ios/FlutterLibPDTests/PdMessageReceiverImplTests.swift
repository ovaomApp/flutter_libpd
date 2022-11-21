//
//  PdMessageReceiverImplTests.swift
//  FlutterLibPDTests
//
//  Created by flav on 31/05/2022.
//

import XCTest
import libpd_ios
import flutter_libpd

class PdMessageReceiverImplTests: SetupPdEnvironmentXCTestCase {
    
    func testAddListenerObservesEventsForASource() throws {
        let sut = makeSUT()
        let expectation = XCTestExpectation()
        let expectedEvents = getEventsForAllMessages(source: anyReceiver())
        
        var receivedEvents: [ReceivedEvent] = []
        sut.addListener(source: anyReceiver()) { receivedEvent in
            receivedEvents.append(receivedEvent)
            if (receivedEvents.count == expectedEvents.count) {
                expectation.fulfill()
            }
        }
        
        try sendAllMessages(messenger: pdController, source: anyReceiver())
        wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(receivedEvents, expectedEvents)
    }
    
    func testAddListenerObservesEventForSources() throws {
        let sut = makeSUT()
        
        try expectListenerReceives(ReceivedEvent(source: anyReceiver()), forSource: anyReceiver(), sut: sut) {
            try sendBang(anyReceiver(), messenger: pdController)
        }
        
        try expectListenerReceives(ReceivedEvent(source: anotherSource()), forSource: anotherSource(), sut: sut) {
            try sendBang(anotherSource(), messenger: pdController)
        }
    }
    
    func testAddListenerWithSameSourceObservesTheLastOne() throws {
        let sut = makeSUT()
        
        let firstExpectation = makeInvertedExpectation(source: anyReceiver())
        sut.addListener(source: anyReceiver()) { _ in
            firstExpectation.fulfill()
        }
        
        let secondExpectation = XCTestExpectation()
        sut.addListener(source: anyReceiver()) { _ in
            secondExpectation.fulfill()
        }
        
        try sendBang(anyReceiver(), messenger: pdController)
        wait(for: [firstExpectation, secondExpectation], timeout: timeout)
    }
    
    func testAddListenerWithSameSourceObservesOnlyOnceTheLastOne() throws {
        let sut = makeSUT()
        sut.addListener(source: anyReceiver()) { _ in }

        let expectation = XCTestExpectation()
        var callCount = 0
        sut.addListener(source: anyReceiver()) { _ in
            callCount += 1
            expectation.fulfill()
        }
        
        try sendBang(anyReceiver(), messenger: pdController)
        wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(callCount, 1)
    }
    
    func testRemoveListenerDoesNotObserveTheSourceAnymore() throws {
        let sut = makeSUT()
        let expectation = makeInvertedExpectation(source: anyReceiver())
        sut.addListener(source: realReceiver()) { _ in
            expectation.fulfill()
        }
        
        sut.removeListener(source: realReceiver())

        try sendBang(realReceiver(), messenger: pdController)
        wait(for: [expectation], timeout: timeout)
    }
        
    func testRemoveAllListenersDoesNotObserveAnySource() throws {
        let sut = makeSUT()
        
        let expectation = makeInvertedExpectation(source: anyReceiver())
        sut.addListener(source: realReceiver()) { _ in
            expectation.fulfill()
        }
        
        let anotherExpectation = makeInvertedExpectation(source: anotherSource())
        sut.addListener(source: anotherSource()) { _ in
            anotherExpectation.fulfill()
        }
        
        sut.removeAllListeners()

        try sendBang(realReceiver(), messenger: pdController)
        try sendBang(anotherSource(), messenger: pdController)
        wait(for: [expectation, anotherExpectation], timeout: timeout)
    }
    
    func testDisposeDoesNotObserveAnySource() throws {
        let sut = makeSUT()
        let expectation = makeInvertedExpectation(source: realReceiver())
        sut.addListener(source: realReceiver()) { _ in
            expectation.fulfill()
        }
        
        sut.dispose()

        try sendBang(realReceiver(), messenger: pdController)
        wait(for: [expectation], timeout: timeout)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> PdMessageReceiver {
        let dispatcher = PdDispatcher()
        let sut = PdMessageReceiverImpl(dispatcher: dispatcher)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(dispatcher, file: file, line: line)
        addTeardownBlock { [weak dispatcher] in
            dispatcher?.removeAllListeners()
            PdBase.setDelegate(nil)
        }
        return sut
    }
    
    private func expectListenerReceives(_ expectedEvent: ReceivedEvent, forSource givenSource: String, sut: PdMessageReceiver, file: StaticString = #filePath, line: UInt = #line, when action: () throws -> Void ) throws {
        let expectation = XCTestExpectation()
        var event: ReceivedEvent?
        
        sut.addListener(source: givenSource) { receivedEvent in
            event = receivedEvent
            expectation.fulfill()
        }
        
        try action()
        wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(event, expectedEvent, file: file, line: line)
    }
    
    private func makeInvertedExpectation(source: String) -> XCTestExpectation {
        return makeInvertedExpectation(description: "\(source) Must not be called")
    }
    
    private func sendBang(_ receiver: String, messenger: PdController) throws {
        try messenger.sendBang(anyBangMessage(receiver))
    }
    
    private func getEventsForAllMessages(source: String) -> [ReceivedEvent] {
        [
            ReceivedEvent(source: source, symbol: nil, arguments: [anyFloatMessage().value]),
            ReceivedEvent(source: source, symbol: nil, arguments: nil),
            ReceivedEvent(source: source, symbol: anySymbolMessage().value, arguments: nil),
            ReceivedEvent(source: source, symbol: nil, arguments: anyListMessage().value),
            ReceivedEvent(source: source, symbol: anyBaseMessage().value, arguments: anyBaseMessage().arguments),
        ]
    }
    
    private func sendAllMessages(messenger: PdController, source: String) throws {
        try messenger.sendFloat(anyFloatMessage(source))
        try messenger.sendBang(anyBangMessage(source))
        try messenger.sendSymbol(anySymbolMessage(source))
        try messenger.sendList(anyListMessage(source))
        try messenger.sendMessage(anyBaseMessage(source))
    }
    
    private func anotherSource() -> String {
        "playExportRec"
    }
}
