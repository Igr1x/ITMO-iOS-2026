//
//  CalendarEvent.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation
import SwiftData

@Model
final class CalendarEvent {
    @Attribute(.unique) var id: String
    var title: String
    var startDate: Date
    var endDate: Date
    var isAllDay: Bool = false
    var googleEventId: String
    var googleCalendarId: String

    init(
        id: String,
        title: String,
        startDate: Date,
        endDate: Date,
        googleEventId: String,
        googleCalendarId: String,
        isAllDay: Bool = false
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.googleEventId = googleEventId
        self.googleCalendarId = googleCalendarId
        self.isAllDay = isAllDay
    }
}
