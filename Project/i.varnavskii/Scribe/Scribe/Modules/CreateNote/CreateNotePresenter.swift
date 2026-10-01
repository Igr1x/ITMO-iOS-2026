//
//  CreateNotePresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Observation

@Observable
final class CreateNotePresenter {
    
    private let interactor: CreateNoteInteractor
    private let router: CreateNoteRouter
    
    var subjects: [Subject] = []
    var selectedSubject: Subject?
    
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
        guard let selectedSubject else {
            return
        }
        interactor.createNote(title, subjectId: selectedSubject.id)
    }
    
    func backButtonTapped() {
        router.back()
    }
    
    func createSubjTapped() {
        router.openCreateSubj()
    }
}
