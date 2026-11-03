//
//  NoteContentRepository.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

import Foundation

nonisolated protocol NoteContentRepository: Sendable {
    func load(noteID: UUID) async throws -> String
    func save(_ text: String, noteID: UUID) async throws
    func delete(noteIDs: [UUID]) async throws
}
