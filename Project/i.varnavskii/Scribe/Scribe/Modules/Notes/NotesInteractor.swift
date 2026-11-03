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
    private let contentRepository: any NoteContentRepository

    init(
        notesRepo: NotesRepository,
        subjectRepo: SubjectRepository,
        contentRepository: any NoteContentRepository
    ) {
        self.notesRepo = notesRepo
        self.subjectRepo = subjectRepo
        self.contentRepository = contentRepository
    }

    func getNotes() -> [Note] {
        return notesRepo.getNotes()
    }

    func getSubjects() -> [Subject] {
        return subjectRepo.getAll().sorted { $0.title < $1.title }
    }

    func deleteNotes(ids: [UUID]) async throws {
        // Сначала сохраняем удаление метаданных. При ошибке БД текст не трогаем.
        try notesRepo.delete(ids: ids)
        try await contentRepository.delete(noteIDs: ids)
    }
}
