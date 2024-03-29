//
//  Pierre_Feuille_CiseauxUITestsLaunchTests.swift
//  Pierre_Feuille_CiseauxUITests
//
//  Created by marhuenda joris on 22/11/2021.
//

import XCTest

class Pierre_Feuille_CiseauxUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
