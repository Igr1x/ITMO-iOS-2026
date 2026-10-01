//
//  HomePageInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class HomePageInteractor {
    private let notesRepo: NotesRepository
    
    init(notesRepo: NotesRepository) {
        self.notesRepo = notesRepo
    }
    
    func getNotes() -> [Note] {
        return notesRepo.getNotes()
    }
}
