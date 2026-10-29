//
//  ICalendarParser.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation

nonisolated struct ICalendarParser {
    func parse(_ data: Data, calendarID: String, interval: DateInterval) throws -> CalendarImportPreview {
        guard let text = String(data: data, encoding: .utf8) else {
            throw CalendarImportError.invalidCalendar
        }

        let calendar = text.replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\n ", with: "")
            .replacingOccurrences(of: "\n\t", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines.union(CharacterSet(charactersIn: "\u{FEFF}")))
        guard calendar.hasPrefix("BEGIN:VCALENDAR"), calendar.hasSuffix("END:VCALENDAR") else {
            throw CalendarImportError.invalidCalendar
        }
        let lines = calendar.components(separatedBy: "\n")
        let name = lines.first { $0.hasPrefix("X-WR-CALNAME:") }?
            .dropFirst("X-WR-CALNAME:".count) ?? "Google Calendar"
        let zoneName = lines.first { $0.hasPrefix("X-WR-TIMEZONE:") }?
            .dropFirst("X-WR-TIMEZONE:".count)
        let timezone = zoneName.flatMap { TimeZone(identifier: String($0)) } ?? .current
        var events: [CalendarEventModel] = []
        var skipped = 0

        // Каждый блок BEGIN:VEVENT ... END:VEVENT — одно событие.
        for block in calendar.components(separatedBy: "BEGIN:VEVENT").dropFirst() {
            try Task.checkCancellation()
            guard let end = block.range(of: "END:VEVENT") else {
                throw CalendarImportError.invalidCalendar
            }
            let fields = readFields(String(block[..<end.lowerBound]))
            if fields["STATUS"]?.value == "CANCELLED" { continue }
            guard let event = parseEvent(fields, calendarID: calendarID, timezone: timezone) else {
                skipped += 1
                continue
            }
            guard event.startDate < interval.end,
                  event.endDate > interval.start ||
                  (event.endDate == event.startDate && event.startDate >= interval.start) else { continue }
            events.append(event)
        }
        return CalendarImportPreview(calendarName: unescape(String(name)),
                                     events: events.sorted { $0.startDate < $1.startDate },
                                     skippedEvents: skipped)
    }

    private func parseEvent(
        _ fields: [String: (header: String, value: String)],
        calendarID: String,
        timezone: TimeZone
    ) -> CalendarEventModel? {
        if ["RRULE", "RDATE", "EXDATE", "RECURRENCE-ID", "DURATION"].contains(where: { fields[$0] != nil }) {
            return nil
        }
        guard let uid = fields["UID"]?.value, !uid.isEmpty,
              let startField = fields["DTSTART"],
              let start = parseDate(startField, timezone: timezone) else { return nil }
        let allDay = startField.value.count == 8
        let finish: Date
        if let endField = fields["DTEND"] {
            guard (endField.value.count == 8) == allDay,
                  let date = parseDate(endField, timezone: timezone), date >= start else { return nil }
            finish = date
        } else {
            finish = allDay ? Calendar.current.date(byAdding: .day, value: 1, to: start)! : start
        }
        let title = fields["SUMMARY"]?.value ?? ""
        return CalendarEventModel(
            id: "\(calendarID.utf8.count):\(calendarID)\(uid.utf8.count):\(uid):single",
            title: title.isEmpty ? "Без названия" : unescape(title),
            startDate: start,
            endDate: finish,
            isAllDay: allDay,
            googleEventId: uid,
            googleCalendarId: calendarID
        )
    }

    private func readFields(_ block: String) -> [String: (header: String, value: String)] {
        var fields: [String: (header: String, value: String)] = [:]
        var insideAlarm = false
        for line in block.components(separatedBy: "\n") {
            // У напоминания тоже бывает SUMMARY; оно не должно заменить название события.
            if line == "BEGIN:VALARM" { insideAlarm = true; continue }
            if line == "END:VALARM" { insideAlarm = false; continue }
            guard !insideAlarm, let colon = line.firstIndex(of: ":") else { continue }
            let header = String(line[..<colon])
            guard let key = header.split(separator: ";").first else { continue }
            fields[String(key)] = (header, String(line[line.index(after: colon)...]))
        }
        return fields
    }

    private func parseDate(_ field: (header: String, value: String), timezone: TimeZone) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.isLenient = false
        formatter.timeZone = timezone
        if field.value.count == 8 {
            // Дата без времени означает событие на весь день.
            formatter.dateFormat = "yyyyMMdd"
            formatter.timeZone = .current
        } else if field.value.hasSuffix("Z") {
            formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
        } else {
            formatter.dateFormat = "yyyyMMdd'T'HHmmss"
            if let parameter = field.header.components(separatedBy: ";").first(where: { $0.hasPrefix("TZID=") }) {
                let name = String(parameter.dropFirst(5)).replacingOccurrences(of: "\"", with: "")
                guard let zone = TimeZone(identifier: name) else { return nil }
                formatter.timeZone = zone
            }
        }
        guard let date = formatter.date(from: field.value),
              formatter.string(from: date) == field.value else { return nil }
        return date
    }

    private func unescape(_ text: String) -> String {
        var result = ""
        var escaped = false
        for character in text {
            if escaped {
                result.append(character == "n" || character == "N" ? "\n" : character)
                escaped = false
            } else if character == "\\" { escaped = true }
            else { result.append(character) }
        }
        return result
    }
}
