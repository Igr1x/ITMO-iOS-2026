//
//  ImportedCalendarEvent.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation

nonisolated struct CalendarEventModel: Identifiable, Sendable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
    // iCalendar UID, not the Google Calendar REST API event ID.
    let googleEventId: String
    let googleCalendarId: String
}

nonisolated struct CalendarImportPreview: Sendable {
    let calendarName: String
    let events: [CalendarEventModel]
    let skippedEvents: Int
}

nonisolated enum CalendarImportError: LocalizedError {
    case invalidURL, invalidCalendar
    case httpStatus(Int), network

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Вставьте HTTPS-ссылку в формате iCal из настроек Google Calendar."
        case .invalidCalendar:
            "По ссылке получен не календарь iCal или файл повреждён."
        case .httpStatus(let status):
            "Google Calendar вернул ошибку \(status). Проверьте ссылку и доступ к календарю."
        case .network:
            "Не удалось загрузить календарь. Проверьте подключение и повторите попытку."
        }
    }
}
