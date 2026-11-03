//
//  NotesRouter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

final class NotesRouter {
    private let appRouter: AppRouter

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }

    func openCreateNote() {
        appRouter.navigate(to: .createNote)
    }

    func openNote(_ note: Note) {
        appRouter.navigate(to: .editNote(note))
    }
}
