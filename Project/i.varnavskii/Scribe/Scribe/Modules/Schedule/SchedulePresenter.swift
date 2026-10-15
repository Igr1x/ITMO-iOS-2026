//
//  SchedulePresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation
import Observation

@Observable
final class SchedulePresenter {
    private let interactor: ScheduleInteractor

    var selectedDate = Date()
    var events: [CalendarEvent] = []
    var errorMessage: String?

    init(interactor: ScheduleInteractor) {
        self.interactor = interactor
    }

    var eventsForSelectedDay: [CalendarEvent] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: selectedDate)
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        return events.filter {
            $0.startDate < end && ($0.endDate > start || ($0.startDate == $0.endDate && $0.startDate >= start))
        }.sorted {
            if $0.isAllDay != $1.isAllDay { return $0.isAllDay }
            return $0.startDate < $1.startDate
        }
    }

    func reload() {
        do {
            events = try interactor.getEvents()
            errorMessage = nil
        } catch {
            errorMessage = "Не удалось прочитать сохранённые события."
        }
    }

    func didImport(firstEventDate: Date?) {
        if let firstEventDate { selectedDate = firstEventDate }
        reload()
    }

}
