//
//  CreateNotePresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class CreateNotePresenter {
    
    private let interactor: CreateNoteInteractor
    private let router: CreateNoteRouter
    
    init(
        interactor: CreateNoteInteractor,
        router: CreateNoteRouter
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func saveButtonTapped(title: String) {
        interactor.createNote(title)
        
    }
    
    func backButtonTapped() {
        router.back()
    }
}
