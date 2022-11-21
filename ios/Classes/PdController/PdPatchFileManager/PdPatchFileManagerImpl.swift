//
//  PdPatchFileManagerImpl.swift
//  flutter_libpd
//
//  Created by flav on 25/05/2022.
//

import Foundation
import libpd_ios

public class PdPatchFileManagerImpl: PdPatchFileManager {

    public init() {}
    
    private var openedFiles: [(PatchFile, PdFile)] = []
    
    private func findPatchIndex(_ file: PatchFile) -> Int? {
        openedFiles.firstIndex(where: { $0.0 == file })
    }
    
    private func isPatchOpened(_ file: PatchFile) -> Bool {
        findPatchIndex(file) != nil
    }
    
    public var openedPatches: [PatchFile] {
        openedFiles.map { $0.0 }
    }
    
    public func openPatch(_ file: PatchFile) throws {
        if isPatchOpened(file) { return }
        guard let pdFile = PdFile.openNamed(file.name, path: file.path) else {
            throw PatchFileError.openFailed(file)
        }
        openedFiles.append((file, pdFile))
    }
    
    public func closePatch(_ file: PatchFile) {
        guard let index = findPatchIndex(file) else { return }
        openedFiles[index].1.close()
        openedFiles.remove(at: index)
    }
}
