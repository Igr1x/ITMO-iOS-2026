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
    
    init(
        interactor: HomePageInteractor,
        router: HomePageRouter
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func onAppear() {
        notes = interactor.getNotes(limit: 2)
    }
    
    func createNoteButtonTapped() {
        router.openCreateNote()
    }
    
}
