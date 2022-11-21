//
//  PatchFileManager.swift
//  Runner
//
//  Created by flav on 24/05/2022.
//

import Foundation

public protocol PdPatchFileManager {
    var openedPatches: [PatchFile] { get }
    func openPatch(_ file: PatchFile) throws
    func closePatch(_ file: PatchFile)
}

public struct PatchFile: Equatable {
    public let name: String
    public let path: String

    public init(name: String, path: String) {
        self.name = name
        self.path = path
    }
    
    public var fullPath: String { path + name }
}

public enum PatchFileError: Error {
    case openFailed(PatchFile)
}
