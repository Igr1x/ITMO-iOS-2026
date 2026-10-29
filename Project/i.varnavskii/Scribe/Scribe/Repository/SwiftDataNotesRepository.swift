//
//  SwiftDataNotesRepository.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation
import SwiftData

final class SwiftDataNotesRepository: NotesRepository {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ note: Note) {
        let noteId = note.id
        let descriptor = FetchDescriptor<NoteModel>(
            predicate: #Predicate { $0.id == noteId }
        )

        if let existing = try? context.fetch(descriptor).first {
            existing.title = note.title
            existing.subjectId = note.subjectId
            existing.createdAt = note.createdAt
        } else {
            context.insert(NoteModel(note: note))
        }

        try? context.save()
    }

    func getNotes() -> [Note] {
        let descriptor = FetchDescriptor<NoteModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        let models = (try? context.fetch(descriptor)) ?? []
        return models.map { $0.entity }
    }

    func delete(_ title: String) {
        let descriptor = FetchDescriptor<NoteModel>(
            predicate: #Predicate { $0.title == title }
        )

        guard let models = try? context.fetch(descriptor) else {
            return
        }

        models.forEach { context.delete($0) }
        try? context.save()
    }

    func getNotes(limit: Int, offset: Int) -> [Note] {
        var descriptor = FetchDescriptor<NoteModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        descriptor.fetchOffset = offset


        let models = (try? context.fetch(descriptor)) ?? []
        return models.map{ $0.entity }
    }

    func delete(ids: [UUID]) {
        let descriptor = FetchDescriptor<NoteModel>(
            predicate: #Predicate { ids.contains($0.id) }
        )

        guard let models = try? context.fetch(descriptor) else {
            return
        }

        models.forEach { context.delete($0) }
        try? context.save()
    }
}
