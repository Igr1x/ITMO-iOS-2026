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
    
    func getNotes(limit: Int, offset: Int = 0) -> [Note] {
        return notesRepo.getNotes(limit: limit, offset: offset)
    }
}
