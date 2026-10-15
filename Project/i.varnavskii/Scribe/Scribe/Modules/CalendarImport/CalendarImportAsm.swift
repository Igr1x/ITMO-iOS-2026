//
//  CalendarImportAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation

enum CalendarImportAsm {
    static func build(
        repository: CalendarEventRepository,
        onImported: @escaping (Date?) -> Void
    ) -> CalendarImportView {
        let interactor = CalendarImportInteractor(
            repository: repository,
            service: GoogleCalendarImportService()
        )
        let presenter = CalendarImportPresenter(interactor: interactor)

        return CalendarImportView(presenter: presenter, onImported: onImported)
    }
}
