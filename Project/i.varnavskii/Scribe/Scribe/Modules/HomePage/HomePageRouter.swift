//
//  HomePageRouter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class HomePageRouter {

    private let appRouter: AppRouter

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }

    func openCreateNote() {
        appRouter.navigate(to: .createNote)
    }
}
