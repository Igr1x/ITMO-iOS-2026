//
//  GoogleCalendarImportService.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation

nonisolated protocol CalendarImportService: Sendable {
    func preview(link: String, interval: DateInterval) async throws -> CalendarImportPreview
}

nonisolated struct GoogleCalendarImportService: CalendarImportService {
    private let session: URLSession

    init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }

    static func calendarURL(from link: String) throws -> (url: URL, calendarID: String) {
        guard let url = URL(string: link.trimmingCharacters(in: .whitespacesAndNewlines)),
              url.scheme == "https", ["calendar.google.com", "www.google.com"].contains(url.host ?? ""),
              url.path.hasPrefix("/calendar/ical/"), url.path.hasSuffix(".ics"),
              url.pathComponents.count >= 6 else {
            throw CalendarImportError.invalidURL
        }
        return (url, url.pathComponents[3])
    }

    @concurrent
    func preview(link: String, interval: DateInterval) async throws -> CalendarImportPreview {
        let source = try Self.calendarURL(from: link)
        var request = URLRequest(url: source.url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        request.setValue("text/calendar", forHTTPHeaderField: "Accept")

        // Один запрос: получаем весь файл календаря и HTTP-ответ.
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            if Task.isCancelled { throw CancellationError() }
            throw CalendarImportError.network
        }
        try Task.checkCancellation()
        guard let http = response as? HTTPURLResponse else { throw CalendarImportError.network }
        guard (200...299).contains(http.statusCode) else { throw CalendarImportError.httpStatus(http.statusCode) }

        // Преобразуем текст iCal в события для предпросмотра
        return try ICalendarParser().parse(data, calendarID: source.calendarID, interval: interval)
    }
}
