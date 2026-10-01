//
//  NotesInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation

final class NotesInteractor {
    
    private let notesRepo: NotesRepository
    private let subjectRepo: SubjectRepository
    
    init(
        notesRepo: NotesRepository,
        subjectRepo: SubjectRepository
    ) {
        self.notesRepo = notesRepo
        self.subjectRepo = subjectRepo
    }
    
    func getNotes() -> [Note] {
        return notesRepo.getNotes()
    }
    
    func getSubjects() -> [Subject] {
        return subjectRepo.getAll().sorted { $0.title < $1.title }
    }
    
    func deleteNotes(ids: [UUID]) {
        notesRepo.delete(ids: ids)
    }
}
