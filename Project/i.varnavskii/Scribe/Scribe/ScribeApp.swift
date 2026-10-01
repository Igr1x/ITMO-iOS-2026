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

    @State private var router = AppRouter()

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

        return WindowGroup {
            NavigationStack(path: $router.path) {

                HomePageAsm.build(
                    appRouter: router,
                    notesRepo: notesRepo
                )
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {

                    case .createNote:
                        CreateNoteAsm.build(
                            appRouter: router,
                            notesRepository: notesRepo,
                            subjectRepository: subjRepo
                        )
                    
                    case .createSubject:
                        CreateSubjectAsm.build(
                            appRouter: router,
                            subjectRepository: subjRepo
                        )
                    }
                    
                }
            }
        }
    }
}
