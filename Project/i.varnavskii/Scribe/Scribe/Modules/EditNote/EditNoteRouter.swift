//
//  EditNoteRouter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

final class EditNoteRouter {
    private let appRouter: AppRouter

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }

    func back() {
        appRouter.back()
    }
}
