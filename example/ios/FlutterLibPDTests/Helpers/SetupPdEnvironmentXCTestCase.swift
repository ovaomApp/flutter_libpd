//
//  SetupPdEnvironmentXCTestCase.swift
//  FlutterLibPDTests
//
//  Created by flav on 01/06/2022.
//

import XCTest
import flutter_libpd

class SetupPdEnvironmentXCTestCase: XCTestCase {
    var pdController: PdController!
    
    override func setUp() {
        setupPdControllerState()
    }
    
    override func tearDown() {
        undoPdControllerSideEffects()
    }
    
    private func setupPdControllerState() {
        pdController = PdController()
        try? pdController.openPatch(anyPatchFile())
    }
    
    private func undoPdControllerSideEffects() {
        pdController.closePatch(anyPatchFile())
        pdController = nil
    }
}
