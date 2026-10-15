//
//  ScheduleInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

final class ScheduleInteractor {
    private let repository: CalendarEventRepository

    init(repository: CalendarEventRepository) {
        self.repository = repository
    }

    func getEvents() throws -> [CalendarEvent] {
        try repository.getEvents()
    }
}
