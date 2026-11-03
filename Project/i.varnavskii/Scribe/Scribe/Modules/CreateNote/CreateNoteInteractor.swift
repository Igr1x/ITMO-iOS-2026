//
//  CreateNoteInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation

final class CreateNoteInteractor {

    private let repo: NotesRepository
    private let subjectRepo: SubjectRepository

    init(
        repo: NotesRepository,
        subjectRepo: SubjectRepository
    ) {
        self.repo = repo
        self.subjectRepo = subjectRepo
    }

    func getSubjects() -> [Subject] {
        return subjectRepo.getAll().sorted { $0.title < $1.title }
    }

    func createNote(_ title: String, subjectId: UUID) throws -> Note {
        let note = Note(
            id: UUID(),
            title: title,
            subjectId: subjectId,
            createdAt: Int(Date().timeIntervalSince1970)
        )
        try repo.save(note)
        return note
    }
}
