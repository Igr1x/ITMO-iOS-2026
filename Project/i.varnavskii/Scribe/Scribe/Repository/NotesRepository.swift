//
//  NoteRepository.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation

protocol NotesRepository {
    func save(_ note: Note)

    func getNotes() -> [Note]

    func delete(_ title: String)

    func getNotes(limit: Int, offset: Int) -> [Note]

    func delete(ids: [UUID])
}

final class StubNotesRepository: NotesRepository {
    private var notes: [String: Note] = [:]

    func save(_ note: Note) {
        notes[note.title] = note
    }

    func getNotes() -> [Note] {
        return notes.map { $0.value }
    }

    func delete(_ title: String) {
        notes.removeValue(forKey: title)
    }

    func getNotes(limit: Int, offset: Int) -> [Note] {
        return []
    }

    func delete(ids: [UUID]) {
        for (title, note) in notes where ids.contains(note.id) {
            notes.removeValue(forKey: title)
        }
    }
}
