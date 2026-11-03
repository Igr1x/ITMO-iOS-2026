//
//  EditNoteInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

import Foundation

final class EditNoteInteractor {
    private let noteID: UUID
    private let repository: any NoteContentRepository

    init(noteID: UUID, repository: any NoteContentRepository) {
        self.noteID = noteID
        self.repository = repository
    }

    func loadText() async throws -> String {
        try await repository.load(noteID: noteID)
    }

    func saveText(_ text: String) async throws {
        try await repository.save(text, noteID: noteID)
    }
}
