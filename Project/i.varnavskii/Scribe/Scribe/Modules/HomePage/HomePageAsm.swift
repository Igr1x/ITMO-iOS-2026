//
//  HomePageAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

enum HomePageAsm {

    static func build(
        appRouter: AppRouter,
        notesRepo: NotesRepository
    ) -> HomePageView {

        let interactor = HomePageInteractor(
            notesRepo: notesRepo
        )

        let router = HomePageRouter(
            appRouter: appRouter
        )

        let presenter = HomePagePresenter(
            interactor: interactor,
            router: router
        )

        return HomePageView(
            presenter: presenter
        )
    }
}
