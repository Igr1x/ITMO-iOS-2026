//
//  ScribeApp.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI
import SwiftData

@main
struct ScribeApp: App {

    private let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: NoteModel.self,
                SubjectModel.self
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
                notesSearchWorker: notesSearchWorker
            )
        }
    }
}
