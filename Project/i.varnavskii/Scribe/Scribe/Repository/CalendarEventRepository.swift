//
//  CalendarEventRepository.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation
import SwiftData

struct CalendarImportResult {
    let inserted: Int
    let updated: Int
}

final class CalendarEventRepository {
    private let context: ModelContext

    init(container: ModelContainer) {
        
        context = ModelContext(container)
        context.autosaveEnabled = false
    }

    func getEvents() throws -> [CalendarEvent] {
        try context.fetch(FetchDescriptor<CalendarEvent>(
            sortBy: [SortDescriptor(\.startDate), SortDescriptor(\.title)]
        ))
    }

    func save(_ events: [CalendarEventModel]) throws -> CalendarImportResult {
        let existing = try getEvents()
        var byID = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })
        var inserted = 0
        var updated = 0
        do {
            for event in events {
                if let model = byID[event.id] {
                    model.title = event.title
                    model.startDate = event.startDate
                    model.endDate = event.endDate
                    model.isAllDay = event.isAllDay
                    updated += 1
                } else {
                    let model = CalendarEvent(
                        id: event.id, title: event.title,
                        startDate: event.startDate, endDate: event.endDate,
                        googleEventId: event.googleEventId,
                        googleCalendarId: event.googleCalendarId,
                        isAllDay: event.isAllDay
                    )
                    context.insert(model)
                    byID[event.id] = model
                    inserted += 1
                }
            }
            try context.save()
            return CalendarImportResult(inserted: inserted, updated: updated)
        } catch {
            context.rollback()
            throw error
        }
    }
}
