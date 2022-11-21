//
//  Messages+Equatable.swift
//  FlutterLibPDTests
//
//  Created by flav on 23/05/2022.
//

import Foundation
import flutter_libpd

extension FloatMessage: Equatable {
    public static func == (lhs: FloatMessage, rhs: FloatMessage) -> Bool {
        lhs.receiver == rhs.receiver &&
        lhs.value == rhs.value
    }
}

extension BangMessage: Equatable {
    public static func == (lhs: BangMessage, rhs: BangMessage) -> Bool {
        lhs.receiver == rhs.receiver
    }
}

extension SymbolMessage: Equatable {
   public static func == (lhs: SymbolMessage, rhs: SymbolMessage) -> Bool {
        lhs.receiver == rhs.receiver &&
        lhs.value == rhs.value
    }
}

extension ListMessage: Equatable {
    public static func == (lhs: ListMessage, rhs: ListMessage) -> Bool {
        lhs.receiver == rhs.receiver &&
        Array.isEqualTo(lhs: lhs.value, rhs: rhs.value)
    }
}

extension ArgumentMessage: Equatable {
    public static func == (lhs: ArgumentMessage, rhs: ArgumentMessage) -> Bool {
        lhs.receiver == rhs.receiver &&
        lhs.value == rhs.value &&
        Array.isEqualTo(lhs: lhs.arguments, rhs: rhs.arguments)
    }
}

extension Array where Element == Any {
    static func isEqualTo(lhs: [Any]?, rhs: [Any]?) -> Bool {
        isEqualTo(lhs: lhs ?? [], rhs: rhs ?? [])
    }
    
    static func isEqualTo(lhs: [Any], rhs: [Any]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        let allValues = lhs.enumerated().map { index, value -> Bool in
            if let lhsStr = value as? String, let rhsStr = rhs[index] as? String {
                return lhsStr == rhsStr
            }
            else if let lhsNumber = value as? NSNumber, let rhsNumber = rhs[index] as? NSNumber {
                return lhsNumber == rhsNumber
            }
            else {
               return false
            }
        }
        
        return allValues.allSatisfy { $0 }
    }
}

extension PlaybackConfiguration: Equatable {
    public static func == (lhs: PlaybackConfiguration, rhs: PlaybackConfiguration) -> Bool {
        lhs.sampleRate == rhs.sampleRate &&
        lhs.inputNumberOfChannels == rhs.inputNumberOfChannels &&
        lhs.outputNumberOfChannels == rhs.outputNumberOfChannels &&
        lhs.inputEnabled == rhs.inputEnabled
    }
}

extension ReceivedEvent: Equatable {
    public static func == (lhs: ReceivedEvent, rhs: ReceivedEvent) -> Bool {
        lhs.source == rhs.source &&
        lhs.symbol == rhs.symbol &&
        Array.isEqualTo(lhs: lhs.arguments, rhs: rhs.arguments)
    }
}
