//
//  SwiftFlutterLibpdPlugin+PatchHelpers.swift
//  flutter_libpd
//
//  Created by flav on 30/05/2022.
//

import Foundation

// MARK: - Patch Extension Helper

extension SwiftFlutterLibpdPlugin {
    
    public func openPatch(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let patchFile = makePatchFile(arguments) else {
            return result(makePatchError(arguments))
        }
        
        do {
            try pdController.openPatch(patchFile)
            result(nil)
        } catch {
            result(FlutterError(code: "OPEN_PATCH_FAILED", message: "unable to open patch: \(patchFile.fullPath)", details: arguments))
        }
    }
    
    public func closePatch(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let patchFile = makePatchFile(arguments) else {
            return result(makePatchError(arguments))
        }
        
        pdController.closePatch(patchFile)
        result(nil)
    }
    
    private func makePatchError(_ arguments: Any?) -> FlutterError {
        FlutterError(code: "INVALID_PARAMETERS", message: "Expected parameters: ['patchName': String, 'path': String]", details: arguments)
    }
    
    private func makePatchFile(_ arguments: Any?) -> PatchFile? {
        guard let json = arguments as? [String: String] else {
            return nil
        }
        return PatchFile(fromJson: json)
    }
}

extension PatchFile {
    init?(fromJson json: [String: String]) {
        guard let patchName = json["patchName"],
              let path = json["path"] else {
                  return nil
              }
        self.init(name: patchName, path: path)
    }
}
