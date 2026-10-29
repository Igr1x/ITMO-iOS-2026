//
//  BackgroundTasks.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 08.10.2026.
//

import Foundation

struct NotesSearchWorker {

    @concurrent
    func search(
        notes: [Note],
        subjects: [Subject],
        query: String
    ) async throws -> [NotesGroup] {
        let subjectsById = Dictionary(
            uniqueKeysWithValues: subjects.map { ($0.id, $0) }
        )

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered = trimmed.isEmpty
            ? notes
            : try notes.filter {
                try Task.checkCancellation()
                return $0.title.localizedCaseInsensitiveContains(trimmed)
            }

        let grouped = Dictionary(grouping: filtered) { $0.subjectId }

        var result: [NotesGroup] = grouped.map { subjectId, notes in
            NotesGroup(
                id: subjectId,
                title: subjectsById[subjectId]?.title ?? "Без предмета",
                notes: notes.sorted { $0.createdAt > $1.createdAt }
            )
        }

        result.sort { $0.title < $1.title }
        return result
    }
}
