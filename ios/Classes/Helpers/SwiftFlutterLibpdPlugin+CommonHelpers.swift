//
//  SwiftFlutterLibpdPlugin+CommonHelpers.swift
//  flutter_libpd
//
//  Created by flav on 01/06/2022.
//

import Foundation

// MARK: - Common Extension Helper

extension SwiftFlutterLibpdPlugin {
    
    public func dispose(_ result: @escaping FlutterResult) {
        pdController.dispose()
        result(nil)
    }
    
    public func getAbsolutePath(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let filename = arguments as? String else {
            return result(FlutterError(code: "INVALID_PARAMETERS", message: "Expected parameter: String", details: arguments))
        }
        
        result(bundle.path(forResource: filename, ofType: nil))
    }
}


