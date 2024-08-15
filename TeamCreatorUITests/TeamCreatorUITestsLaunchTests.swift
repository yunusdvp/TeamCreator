//
//  TeamCreatorUITestsLaunchTests.swift
//  TeamCreatorUITests
//
//  Created by Yunus Emre ÖZŞAHİN on 26.07.2024.
//

import XCTest

final class TeamCreatorUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
