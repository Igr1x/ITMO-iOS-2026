//
//  HomePagePresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

@Observable
final class HomePagePresenter {

    private let interactor: HomePageInteractor
    private let router: HomePageRouter

    var notes: [Note] = []
    var subjectTitle: String?

    init(
        interactor: HomePageInteractor,
        router: HomePageRouter
    ) {
        self.interactor = interactor
        self.router = router
    }

    func onAppear() {
        let settings = interactor.getSettings()

        let all = interactor.getNotes(limit: settings.notesLimit)
        if let subjectId = settings.subjectId {
            notes = all.filter { $0.subjectId == subjectId }
            subjectTitle = interactor.getSubject(id: subjectId)?.title
        } else {
            notes = all
            subjectTitle = nil
        }
    }

    func createNoteButtonTapped() {
        router.openCreateNote()
    }

}
