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
        service: any CalendarImportService = GoogleCalendarImportService(),
        onImported: @escaping (Date?) -> Void
    ) -> CalendarImportView {
        let interactor = CalendarImportInteractor(
            repository: repository,
            service: service
        )
        let presenter = CalendarImportPresenter(interactor: interactor)

        return CalendarImportView(presenter: presenter, onImported: onImported)
    }
}
