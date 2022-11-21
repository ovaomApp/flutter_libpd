//
//  PdMessageReceiverImpl.swift
//  flutter_libpd
//
//  Created by flav on 01/06/2022.
//

import Foundation
import libpd_ios

public class PdMessageReceiverImpl: NSObject, PdMessageReceiver {
    private let dispatcher: PdDispatcher
    private var callbacks:[String: ListenerCallback] = [:]
    
    public init(dispatcher: PdDispatcher = PdDispatcher()) {
        self.dispatcher = dispatcher
        PdBase.setDelegate(self.dispatcher)
    }
    
    public func addListener(source: String, callback: @escaping ListenerCallback) {
        if callbacks.doesNotContain(key: source) {
            dispatcher.add(self, forSource: source)
        }
        callbacks[source] = callback
    }
    
    public func removeListener(source: String) {
        callbacks.removeValue(forKey: source)
        dispatcher.remove(self, forSource: source)
    }
    
    public func removeAllListeners() {
        callbacks.keys.forEach { removeListener(source: $0) }
    }
    
    public func dispose() {
        removeAllListeners()
        PdBase.setDelegate(nil)
    }
}

extension PdMessageReceiverImpl: PdListener {
    
   public func receiveMessage(_ message: String, withArguments arguments: [Any], fromSource source: String) {
        callbacks[source]?(ReceivedEvent(source: source, symbol: message, arguments: arguments))
    }
    
    public func receive(_ received: Float, fromSource source: String) {
        callbacks[source]?(ReceivedEvent(source: source, arguments: [received]))
    }
    
    public func receiveSymbol(_ symbol: String, fromSource source: String) {
        callbacks[source]?(ReceivedEvent(source: source, symbol: symbol))
    }
    
    public func receiveBang(fromSource source: String) {
        callbacks[source]?(ReceivedEvent(source: source))
    }
    
    public func receiveList(_ list: [Any], fromSource source: String) {
        callbacks[source]?(ReceivedEvent(source: source, arguments: list))
    }
}

extension Dictionary where Key == String {
    func contains(key: Key) -> Bool {
        keys.contains(key)
    }
    
    func doesNotContain(key: Key) -> Bool {
        !contains(key: key)
    }
}
