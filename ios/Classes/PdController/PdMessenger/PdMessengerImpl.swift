//
//  PdMessengerImpl.swift
//  flutter_libpd
//
//  Created by flav on 30/05/2022.
//

import Foundation
import libpd_ios

public class PdMessengerImpl: PdMessenger {
    
    public init() {}
    
    private func ensureSuccessStatus(_ status: Int32) throws {
        if status != 0 { throw MessageError.messageFailed }
    }
    
    public func sendFloat(_ message: FloatMessage) throws {
        let status = PdBase.send(message.value, toReceiver: message.receiver)
        try ensureSuccessStatus(status)
    }
    
    public func sendBang(_ message: BangMessage) throws {
        let status = PdBase.sendBang(toReceiver: message.receiver)
        try ensureSuccessStatus(status)
    }
    
    public func sendSymbol(_ message: SymbolMessage) throws {
        let status = PdBase.sendSymbol(message.value, toReceiver: message.receiver)
        try ensureSuccessStatus(status)
    }
    
    public func sendList(_ message: ListMessage) throws {
        let status = PdBase.sendList(message.value, toReceiver: message.receiver)
        try ensureSuccessStatus(status)
    }
    
    public func sendMessage(_ message: ArgumentMessage) throws {
        let status = PdBase.sendMessage(message.value, withArguments: message.arguments, toReceiver: message.receiver)
        try ensureSuccessStatus(status)
    }
}
