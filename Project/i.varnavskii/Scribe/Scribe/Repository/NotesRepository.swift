//
//  NoteRepository.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

protocol NotesRepository {
    func save(_ note: Note)
    
    func getNotes() -> [Note]
    
    func delete(_ title: String)
    
    func getNotes(limit: Int, offset: Int) -> [Note]
}

final class StubNotesRepository : NotesRepository {
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
}
