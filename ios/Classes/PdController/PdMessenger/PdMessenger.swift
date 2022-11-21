//
//  PdMessenger.swift
//  Runner
//
//  Created by flav on 23/05/2022.
//

import Foundation

public protocol PdMessenger {
    func sendFloat(_ message: FloatMessage) throws
    func sendBang(_ message: BangMessage) throws
    func sendSymbol(_ message: SymbolMessage) throws
    func sendList(_ message: ListMessage) throws
    func sendMessage(_ message: ArgumentMessage) throws
}

public enum MessageError: Error {
    case messageFailed
}

public struct FloatMessage {
    public let value: Float
    public let receiver: String
    
    public init(value: Float, receiver: String) {
        self.value = value
        self.receiver = receiver
    }
}

public struct BangMessage {
    public let receiver: String

    public init(receiver: String) {
        self.receiver = receiver
    }
}

public struct SymbolMessage {
    public let value: String
    public let receiver: String
    
    public init(value: String, receiver: String) {
        self.value = value
        self.receiver = receiver
    }
}

public struct ListMessage {
    public let value: [Any]
    public let receiver: String
    
    public init(value: [Any], receiver: String) {
        self.value = value
        self.receiver = receiver
    }
}

public struct ArgumentMessage {
    public let value: String
    public let arguments: [Any]
    public let receiver: String
    
    public init(value: String, arguments: [Any], receiver: String) {
        self.value = value
        self.arguments = arguments
        self.receiver = receiver
    }
}
