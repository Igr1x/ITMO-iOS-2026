//
//  CreateNoteInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation

final class CreateNoteInteractor {
    
    private let repo: NotesRepository
    
    init(repo: NotesRepository) {
        self.repo = repo
    }
    
    func createNote(_ title: String) {
        let note = Note(
            id: UUID(),
            title: title,
            subjectId: UUID(),
            createdAt: Int(Date().timeIntervalSince1970)
        )
        
        repo.save(note)
    }
}
