//
//  ReceiveMessageStreamHandler.swift
//  flutter_libpd
//
//  Created by flav on 01/06/2022.
//

import Foundation

public class ReceiveMessageStreamHandler: NSObject, FlutterStreamHandler {
    private let messageReceiver: PdMessageReceiver
    
    public init(messageReceiver: PdMessageReceiver) {
        self.messageReceiver = messageReceiver
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        guard let source = makeSource(arguments) else { return makeError(arguments) }
        messageReceiver.addListener(source: source) { message in
            events(["source": message.source,
                    "symbol": message.symbol,
                    "value": message.arguments] as [String: Any?])
        }
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        guard let source = makeSource(arguments) else { return makeError(arguments) }
        messageReceiver.removeListener(source: source)
        return nil
    }
    
    private func makeSource(_ arguments: Any?) -> String? {
        guard let arguments = arguments as? [String], arguments.count == 1,
              let source = arguments.first, !source.isEmpty else {
                  return nil
              }
        return source
    }
    
    private func makeError(_ arguments: Any?) -> FlutterError {
        FlutterError(code: "INVALID_PARAMETERS", message: "Expected param: [String] of size 1", details: arguments)
    }
}
