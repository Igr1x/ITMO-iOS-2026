//
//  ScribeUITests.swift
//  ScribeUITests
//
//  Created by Варнавский Игорь Витальевич on 22.10.2026.
//

import XCTest

final class ScribeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testCalendarImportOpensAndCloses() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()

        let calendarTab = app.tabBars.buttons["Календарь"]
        XCTAssertTrue(calendarTab.waitForExistence(timeout: 5))
        calendarTab.tap()
        let importButton = app.buttons["calendar.openImport"]
        XCTAssertTrue(importButton.waitForExistence(timeout: 5))
        importButton.tap()

        let importPage = app.navigationBars["Импорт календаря"]
        XCTAssertTrue(importPage.waitForExistence(timeout: 5))

        app.buttons["calendarImport.close"].tap()
        XCTAssertTrue(importPage.waitForNonExistence(timeout: 5))
        XCTAssertTrue(importButton.waitForExistence(timeout: 5))
    }

    @MainActor
    func testValidLinkEnablesDownloadButton() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()
        let calendarTab = app.tabBars.buttons["Календарь"]
        XCTAssertTrue(calendarTab.waitForExistence(timeout: 5))
        calendarTab.tap()
        let importButton = app.buttons["calendar.openImport"]
        XCTAssertTrue(importButton.waitForExistence(timeout: 5))
        importButton.tap()

        let downloadButton = app.buttons["calendarImport.download"]
        XCTAssertTrue(downloadButton.waitForExistence(timeout: 5))
        XCTAssertFalse(downloadButton.isEnabled)

        let linkField = app.descendants(matching: .any)
            .matching(identifier: "calendarImport.link").firstMatch
        XCTAssertTrue(linkField.waitForExistence(timeout: 5))
        linkField.tap()
        linkField.typeText("https://calendar.google.com/calendar/ical/student%40gmail.com/public/basic.ics")

        XCTAssertTrue(downloadButton.isEnabled)
    }
}
