//
//  PdPatchFileManagerImplTest.swift
//  FlutterLibPDTests
//
//  Created by flav on 25/05/2022.
//

import XCTest
import flutter_libpd

class PdPatchFileManagerImplTests: XCTestCase {

    func testOpenPatchFailsOnError() {
        let sut = makeSUT()
        let patchFile = PatchFile(name: "wrongName", path: "wrongPath")
        
        XCTAssertThrowsError(try sut.openPatch(patchFile))
        XCTAssertEqual(sut.openedPatches.count, 0)
    }
    
    func testOpenPatchOpensPatchSuccessfully() {
        let sut = makeSUT()
    
        XCTAssertNoThrow(try sut.openPatch(anyPatchFile()))
        XCTAssertEqual(sut.openedPatches, [anyPatchFile()])
    }
    
    func testOpenPatchManyTimesWithTheSameOpensItOnlyOnce() throws {
        let sut = makeSUT()
    
        try openPatches([anyPatchFile()], sut: sut)
        
        XCTAssertEqual(sut.openedPatches.count, 1)
    }
    
    func testOpenPatchWithManyPatchesOpensAllPatchesSuccessfully() throws {
        let sut = makeSUT()

        try openPatches([anyPatchFile(), anotherPatchFile()], sut: sut)

        XCTAssertEqual(sut.openedPatches, [anyPatchFile(), anotherPatchFile()])
    }
    
    func testClosePatchClosesPatchSuccessfully() throws {
        let sut = makeSUT()
        try sut.openPatch(anyPatchFile())

        sut.closePatch(anyPatchFile())

        XCTAssertEqual(sut.openedPatches.count, 0)
    }
    
    func testClosePatchManyTimesWithTheSameClosesItOnlyOnce() throws {
        let sut = makeSUT()
        try openPatches([anyPatchFile(), anotherPatchFile()], sut: sut)

        closePatches([anyPatchFile(), anyPatchFile()], sut: sut)

        XCTAssertEqual(sut.openedPatches, [anotherPatchFile()])
    }
    
    func testClosePatchWithSomeOpenedPatchesClosesTheSpecifiedOne() throws {
        let sut = makeSUT()
        try openPatches([anyPatchFile(), anotherPatchFile()], sut: sut)
        
        sut.closePatch(anyPatchFile())

        XCTAssertEqual(sut.openedPatches, [anotherPatchFile()])
    }
    

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> PdPatchFileManager {
        let sut = PdPatchFileManagerImpl()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func openPatches(_ files: [PatchFile], sut: PdPatchFileManager) throws {
        try files.forEach {
            try sut.openPatch($0)
        }
    }
    
    private func closePatches(_ files: [PatchFile], sut: PdPatchFileManager) {
        files.forEach(sut.closePatch)
        
    }
    
    private func anotherPatchFile() -> PatchFile {
        anyPatchFile("main2.pd")
    }
}

