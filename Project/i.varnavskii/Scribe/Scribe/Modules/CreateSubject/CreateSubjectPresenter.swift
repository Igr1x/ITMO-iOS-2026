//
//  CreateSubjectPresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class CreateSubjectPresenter {

    private let interactor: CreateSubjectInteractor
    private let router: CreateSubjectRouter

    init(
        interactor: CreateSubjectInteractor,
        router: CreateSubjectRouter
    ) {
        self.interactor = interactor
        self.router = router
    }

    func createSubject(title: String) {
        interactor.saveSubject(title: title)
        router.back()
    }

    func back() {
        router.back()
    }

}
