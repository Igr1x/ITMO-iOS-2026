//
//  ScribeApp.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI
import SwiftData
import Foundation

@main
struct ScribeApp: App {

    private let container: ModelContainer
    private let calendarImportService: any CalendarImportService

    init() {
        var isUITesting = false
        var importService: any CalendarImportService = GoogleCalendarImportService()
        #if DEBUG
        isUITesting = ProcessInfo.processInfo.arguments.contains("--ui-testing")
        if isUITesting,
           let value = ProcessInfo.processInfo.environment["UI_TEST_CALENDAR_IMPORT"],
           let scenario = StubCalendarImportService.Scenario(rawValue: value) {
            importService = StubCalendarImportService(scenario: scenario)
        }
        #endif
        calendarImportService = importService

        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: isUITesting)
            container = try ModelContainer(
                for: NoteModel.self,
                SubjectModel.self,
                CalendarEvent.self,
                configurations: configuration
            )
        } catch {
            fatalError("Не удалось создать ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        let context = container.mainContext
        let notesRepo = SwiftDataNotesRepository(context: context)
        let subjRepo = SwiftDataSubjectRepository(context: context)
        let userDetailsRepo = UserDefaultsUserDetailsRepository()
        let notesSearchWorker = NotesSearchWorker()

        return WindowGroup {
            RootView(
                notesRepo: notesRepo,
                subjRepo: subjRepo,
                userDetailsRepo: userDetailsRepo,
                notesSearchWorker: notesSearchWorker,
                calendarRepository: CalendarEventRepository(container: container),
                calendarImportService: calendarImportService
            )
        }
    }
}
