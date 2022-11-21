//
//  PdMessageReceiver.swift
//  flutter_libpd
//
//  Created by flav on 01/06/2022.
//

import Foundation

public protocol PdMessageReceiver {
    func addListener(source: String, callback: @escaping ListenerCallback)
    func removeListener(source: String)
    func removeAllListeners()
    func dispose()
}

public typealias ListenerCallback = (ReceivedEvent) -> Void

public struct ReceivedEvent {
    public let source: String
    public let symbol: String?
    public let arguments: [Any]?
    
    public init(source: String, symbol: String? = nil, arguments: [Any]? = nil) {
        self.source = source
        self.symbol = symbol
        self.arguments = arguments
    }
}
