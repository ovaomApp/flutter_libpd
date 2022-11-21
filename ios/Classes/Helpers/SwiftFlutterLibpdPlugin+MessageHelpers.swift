//
//  SwiftFlutterLibpdPlugin+MessageHelpers.swift
//  flutter_libpd
//
//  Created by flav on 30/05/2022.
//

import Foundation

// MARK: - Messages Extension Helper

extension SwiftFlutterLibpdPlugin {
    
    static let kMessageKey = "message"
    static let kArgumentsKey = "arguments"
    static let kValueKey = "value"
    static let kReceiverKey = "receiver"
    static let kListKey = "list"
    static let kSymbolKey = "symbol"
    
    // MARK: - Send Float
    
    public func sendFloat(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let json = arguments as? [String: Any], let message = FloatMessage(fromJson: json) else {
            return result(FlutterError(code: "INVALID_PARAMETERS", message: "Expected parameters: [\"\(SwiftFlutterLibpdPlugin.kValueKey)\": Double, \"\(SwiftFlutterLibpdPlugin.kReceiverKey)\": String]", details: arguments))
        }
        
        do {
            try pdController.sendFloat(message)
            result(nil)
        } catch {
            result(FlutterError(code: "SEND_FLOAT_FAILED", message: "unable to send float", details: arguments))
        }
    }
    
    // MARK: - Send Bang
    
    public func sendBang(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let receiver = arguments as? String else {
            return result(FlutterError(code: "INVALID_PARAMETERS", message: "Expected parameter: String", details: arguments))
        }
        
        do {
            try pdController.sendBang(BangMessage(receiver: receiver))
            result(nil)
        } catch {
            result(FlutterError(code: "SEND_BANG_FAILED", message: "unable to send bang", details: arguments))
        }
    }
    
    // MARK: - Send Symbol
    
    public func sendSymbol(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let json = arguments as? [String: String], let message = SymbolMessage(fromJson: json) else {
            return result(FlutterError(code: "INVALID_PARAMETERS", message: "Expected parameters: [\"\(SwiftFlutterLibpdPlugin.kSymbolKey)\": String, \"\(SwiftFlutterLibpdPlugin.kReceiverKey)\": String]", details: arguments))
        }
        
        do {
            try pdController.sendSymbol(message)
            result(nil)
        } catch {
            result(FlutterError(code: "SEND_SYMBOL_FAILED", message: "unable to send symbol", details: arguments))
        }
    }
    
    
    // MARK: - Send List
    
    public func sendList(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let json = arguments as? [String: Any], let message = ListMessage(fromJson: json) else {
            return result(FlutterError(code: "INVALID_PARAMETERS", message: "Expected parameters: [\"\(SwiftFlutterLibpdPlugin.kListKey)\": [Any], \"\(SwiftFlutterLibpdPlugin.kReceiverKey)\": String]", details: arguments))
        }
        
        do {
            try pdController.sendList(message)
            result(nil)
        } catch {
            result(FlutterError(code: "SEND_LIST_FAILED", message: "unable to send list", details: arguments))
        }
    }
    
    // MARK: - Send Message
    
    public func sendMessage(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let json = arguments as? [String: Any], let message = ArgumentMessage(fromJson: json) else {
            return result(FlutterError(code: "INVALID_PARAMETERS", message: "Expected parameters: [\"\(SwiftFlutterLibpdPlugin.kMessageKey)\": String, \"\(SwiftFlutterLibpdPlugin.kArgumentsKey)\": [Any], \"\(SwiftFlutterLibpdPlugin.kReceiverKey)\": String]", details: arguments))
        }
        
        do {
            try pdController.sendMessage(message)
            result(nil)
        } catch {
            result(FlutterError(code: "SEND_MESSAGE_FAILED", message: "unable to send message", details: arguments))
        }
    }
}


extension FloatMessage {
    init?(fromJson json: [String: Any]) {
        guard let value = json[SwiftFlutterLibpdPlugin.kValueKey] as? Double,
              let receiver = json[SwiftFlutterLibpdPlugin.kReceiverKey] as? String
        else { return nil }
        self.init(value: Float(value), receiver: receiver)
    }
}

extension SymbolMessage {
    init?(fromJson json: [String: String]) {
        guard let symbol = json[SwiftFlutterLibpdPlugin.kSymbolKey],
              let receiver = json[SwiftFlutterLibpdPlugin.kReceiverKey]
        else { return nil }
        self.init(value: symbol, receiver: receiver)
    }
}

extension ListMessage {
    init?(fromJson json: [String: Any]) {
        guard let list = json[SwiftFlutterLibpdPlugin.kListKey] as? [Any],
              let receiver = json[SwiftFlutterLibpdPlugin.kReceiverKey] as? String
        else { return nil }
        self.init(value: list, receiver: receiver)
    }
}

extension ArgumentMessage {
    init?(fromJson json: [String: Any]) {
        guard let message = json[SwiftFlutterLibpdPlugin.kMessageKey] as? String,
              let arguments = json[SwiftFlutterLibpdPlugin.kArgumentsKey] as? [Any],
              let receiver = json[SwiftFlutterLibpdPlugin.kReceiverKey] as? String
        else { return nil }
        self.init(value: message, arguments: arguments, receiver: receiver)
    }
}
