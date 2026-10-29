//
//  ScheduleAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation

enum ScheduleAsm {
    static func build(
        repository: CalendarEventRepository,
        importService: any CalendarImportService = GoogleCalendarImportService()
    ) -> ScheduleView {
        let interactor = ScheduleInteractor(repository: repository)
        let presenter = SchedulePresenter(interactor: interactor)

        return ScheduleView(presenter: presenter) { onImported in
            CalendarImportAsm.build(repository: repository, service: importService, onImported: onImported)
        }
    }
}
