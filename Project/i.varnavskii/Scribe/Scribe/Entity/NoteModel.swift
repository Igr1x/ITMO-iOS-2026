//
//  NoteModel.swift
//  Scribe
//

import Foundation
import SwiftData

@Model
final class NoteModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var subjectId: UUID
    var createdAt: Int

    init(
        id: UUID,
        title: String,
        subjectId: UUID,
        createdAt: Int
    ) {
        self.id = id
        self.title = title
        self.subjectId = subjectId
        self.createdAt = createdAt
    }

    convenience init(note: Note) {
        self.init(
            id: note.id,
            title: note.title,
            subjectId: note.subjectId,
            createdAt: note.createdAt
        )
    }

    var entity: Note {
        Note(
            id: id,
            title: title,
            subjectId: subjectId,
            createdAt: createdAt
        )
    }
}