//
//  CreateNotePresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation
import Observation

@Observable
final class CreateNotePresenter {

    private let interactor: CreateNoteInteractor
    private let router: CreateNoteRouter

    var subjects: [Subject] = []
    var selectedSubject: Subject?
    var errorMessage: String?

    init(
        interactor: CreateNoteInteractor,
        router: CreateNoteRouter
    ) {
        self.interactor = interactor
        self.router = router
    }

    func onAppear() {
        subjects = interactor.getSubjects()
        if selectedSubject == nil {
            selectedSubject = subjects.first
        }
    }

    func selectSubject(_ subject: Subject) {
        selectedSubject = subject
    }

    func saveButtonTapped(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let selectedSubject, !trimmed.isEmpty else {
            return
        }
        do {
            let note = try interactor.createNote(trimmed, subjectId: selectedSubject.id)
            router.openNote(note)
        } catch {
            errorMessage = "Не удалось создать конспект: \(error.localizedDescription)"
        }
    }

    func backButtonTapped() {
        router.back()
    }

    func createSubjTapped() {
        router.openCreateSubj()
    }
}
