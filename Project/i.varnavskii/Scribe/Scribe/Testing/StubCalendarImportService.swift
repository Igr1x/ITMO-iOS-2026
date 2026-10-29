//
//  StubCalendarImportService.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 22.10.2026.
//

#if DEBUG
import Foundation

nonisolated struct StubCalendarImportService: CalendarImportService {
    enum Scenario: String, Sendable {
        case success
        case failure
    }

    let scenario: Scenario

    func preview(link: String, interval: DateInterval) async throws -> CalendarImportPreview {
        try Task.checkCancellation()
        if scenario == .failure {
            throw CalendarImportError.network
        }

        let start = interval.start.addingTimeInterval(9 * 60 * 60)
        let event = CalendarEventModel(
            id: "stub-event", title: "Тестовая лекция",
            startDate: start, endDate: start.addingTimeInterval(60 * 60),
            isAllDay: false,
            googleEventId: "stub-event", googleCalendarId: "stub-calendar"
        )
        return CalendarImportPreview(calendarName: "Учебный календарь", events: [event], skippedEvents: 0)
    }
}
#endif
