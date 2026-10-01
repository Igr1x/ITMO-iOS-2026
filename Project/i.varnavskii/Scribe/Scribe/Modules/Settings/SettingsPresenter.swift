//
//  SettingsPresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation
import Observation

@Observable
final class SettingsPresenter {
    
    private let interactor: SettingsInteractor
    
    var notesLimit: Int = UserDefaultsUserDetailsRepository.defaultNotesLimit
    var selectedSubjectId: UUID?
    var subjects: [Subject] = []
    
    let maxNotesLimit = UserDefaultsUserDetailsRepository.maxNotesLimit
    
    init(interactor: SettingsInteractor) {
        self.interactor = interactor
    }
    
    func onAppear() {
        let settings = interactor.getSettings()
        notesLimit = settings.notesLimit
        selectedSubjectId = settings.subjectId
        subjects = interactor.getSubjects()
    }
    
    func selectSubject(_ subject: Subject?) {
        selectedSubjectId = subject?.id
    }
    
    func save() {
        interactor.saveSettings(
            HomePageSettings(
                notesLimit: notesLimit,
                subjectId: selectedSubjectId
            )
        )
    }
}
