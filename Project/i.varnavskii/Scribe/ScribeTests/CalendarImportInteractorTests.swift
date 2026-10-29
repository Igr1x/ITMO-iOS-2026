//
//  CalendarImportInteractorTests.swift
//  ScribeTests
//
//  Created by Варнавский Игорь Витальевич on 22.10.2026.
//

import Foundation
import SwiftData
import XCTest
@testable import Scribe

final class CalendarImportInteractorTests: XCTestCase {
    @MainActor
    func testLoadPreviewPassesArgumentsAndReturnsServiceResult() async throws {
        let expected = CalendarImportPreview(calendarName: "Учебный календарь", events: [], skippedEvents: 0)
        let mock = CalendarImportServiceMock(result: expected)
        let interactor = try makeInteractor(service: mock)
        let link = "https://calendar.google.com/calendar/ical/student%40gmail.com/public/basic.ics"
        let interval = DateInterval(start: Date(timeIntervalSince1970: 0), duration: 86_400)

        let result = try await interactor.loadPreview(link: link, interval: interval)
        
        let callCount = await mock.callCount
        let receivedLink = await mock.receivedLink
        let receivedInterval = await mock.receivedInterval
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(receivedLink, link)
        XCTAssertEqual(receivedInterval, interval)
        XCTAssertEqual(result.calendarName, expected.calendarName)
        XCTAssertEqual(result.events.count, expected.events.count)
        XCTAssertEqual(result.skippedEvents, expected.skippedEvents)
    }

    @MainActor
    func testLoadPreviewPropagatesServiceError() async throws {
        let emptyPreview = CalendarImportPreview(calendarName: "", events: [], skippedEvents: 0)
        let mock = CalendarImportServiceMock(result: emptyPreview, error: .network)
        let interactor = try makeInteractor(service: mock)
        let interval = DateInterval(start: Date(timeIntervalSince1970: 0), duration: 86_400)

        do {
            _ = try await interactor.loadPreview(link: "test-link", interval: interval)
            XCTFail("Interactor должен передать ошибку сервиса вызывающему коду")
        } catch CalendarImportError.network {
        } catch {
            XCTFail("Ожидалась ошибка network, получена \(error)")
        }

        let callCount = await mock.callCount
        XCTAssertEqual(callCount, 1)
    }

    @MainActor
    private func makeInteractor(service: any CalendarImportService) throws -> CalendarImportInteractor {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CalendarEvent.self, configurations: configuration)
        let repository = CalendarEventRepository(container: container)
        return CalendarImportInteractor(repository: repository, service: service)
    }
}

private actor CalendarImportServiceMock: CalendarImportService {
    private let result: CalendarImportPreview
    private let error: CalendarImportError?

    private(set) var callCount = 0
    private(set) var receivedLink: String?
    private(set) var receivedInterval: DateInterval?

    init(result: CalendarImportPreview, error: CalendarImportError? = nil) {
        self.result = result
        self.error = error
    }

    func preview(link: String, interval: DateInterval) async throws -> CalendarImportPreview {
        callCount += 1
        receivedLink = link
        receivedInterval = interval

        if let error { throw error }
        return result
    }
}
