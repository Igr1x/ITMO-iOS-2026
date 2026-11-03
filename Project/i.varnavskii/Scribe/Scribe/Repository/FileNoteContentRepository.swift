//
//  FileNoteContentRepository.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

import Foundation

actor FileNoteContentRepository: NoteContentRepository {
    private let directory: URL

    init(directory: URL = URL.applicationSupportDirectory
        .appendingPathComponent("Scribe/Notes", isDirectory: true)) {
        self.directory = directory
    }

    func load(noteID: UUID) throws -> String {
        do {
            return try String(contentsOf: fileURL(noteID), encoding: .utf8)
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile || error.code == .fileNoSuchFile {
            // Старые конспекты ещё не имеют файла с текстом.
            return ""
        }
    }

    func save(_ text: String, noteID: UUID) throws {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        // Атомарная запись заменяет файл целиком и не оставляет частично записанный текст.
        try text.write(to: fileURL(noteID), atomically: true, encoding: .utf8)
    }

    func delete(noteIDs: [UUID]) throws {
        for noteID in noteIDs {
            do {
                try FileManager.default.removeItem(at: fileURL(noteID))
            } catch let error as CocoaError where error.code == .fileNoSuchFile {
                continue
            }
        }
    }

    private func fileURL(_ noteID: UUID) -> URL {
        directory.appendingPathComponent(noteID.uuidString).appendingPathExtension("txt")
    }
}
