//
//  GoogleCalendarImportServiceTests.swift
//  ScribeTests
//
//  Created by Варнавский Игорь Витальевич on 22.10.2026.
//

import XCTest
@testable import Scribe

final class GoogleCalendarImportServiceTests: XCTestCase {
    func testValidLinkReturnsCalendarID() throws {
        let link = "https://calendar.google.com/calendar/ical/student%40gmail.com/public/basic.ics"

        let result = try GoogleCalendarImportService.calendarURL(from: link)

        XCTAssertEqual(result.calendarID, "student@gmail.com")
        XCTAssertEqual(result.url.absoluteString, link)
    }

    func testLinkFromAnotherWebsiteThrowsError() {
        let link = "https://example.com/calendar.ics"

        XCTAssertThrowsError(try GoogleCalendarImportService.calendarURL(from: link))
    }
}
