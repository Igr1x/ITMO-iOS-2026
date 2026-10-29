//
//  CreateSubjectAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class CreateSubjectAsm {

    static func build(
        appRouter: AppRouter,
        subjectRepository: SubjectRepository
    ) -> CreateSubjectView {

        let interactor = CreateSubjectInteractor(subjectRepo: subjectRepository)

        let router = CreateSubjectRouter(router: appRouter)

        let presenter = CreateSubjectPresenter(
            interactor: interactor,
            router: router
        )

        return CreateSubjectView(presenter: presenter)
    }
}
