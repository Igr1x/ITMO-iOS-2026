//
//  CreateNoteRouter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class CreateNoteRouter {

    private let appRouter: AppRouter

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }

    func back() {
        appRouter.back()
    }

    func openCreateSubj() {
        appRouter.navigate(to: .createSubject)
    }
}
