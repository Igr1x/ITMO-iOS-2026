//
//  CalendarImportInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation

final class CalendarImportInteractor {
    private let repository: CalendarEventRepository
    private let service: any CalendarImportService

    init(repository: CalendarEventRepository, service: any CalendarImportService) {
        self.repository = repository
        self.service = service
    }

    func isValidLink(_ link: String) -> Bool {
        (try? GoogleCalendarImportService.calendarURL(from: link)) != nil
    }

    func loadPreview(link: String, interval: DateInterval) async throws -> CalendarImportPreview {
        try await service.preview(link: link, interval: interval)
    }

    func save(_ events: [CalendarEventModel]) throws -> CalendarImportResult {
        try repository.save(events)
    }
}
