//
//  CreateSubjectRouter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class CreateSubjectRouter {
    private let appRouter: AppRouter

    init(router: AppRouter) {
        self.appRouter = router
    }

    func back() {
        appRouter.back()
    }
}
