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
        // Новый формат имеет приоритет, даже если в нём пустой текст.
        try readTextIfPresent(at: fileURL(noteID, format: "md"))
            ?? readTextIfPresent(at: fileURL(noteID, format: "txt"))
            ?? ""
    }

    func save(_ text: String, noteID: UUID) throws {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        // Старый файл удаляем только после успешной атомарной записи Markdown.
        try text.write(to: fileURL(noteID, format: "md"), atomically: true, encoding: .utf8)
        try removeFileIfPresent(at: fileURL(noteID, format: "txt"))
    }

    func delete(noteIDs: [UUID]) throws {
        for noteID in noteIDs {
            try removeFileIfPresent(at: fileURL(noteID, format: "md"))
            try removeFileIfPresent(at: fileURL(noteID, format: "txt"))
        }
    }

    private func readTextIfPresent(at url: URL) throws -> String? {
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile || error.code == .fileNoSuchFile {
            return nil
        }
    }

    private func removeFileIfPresent(at url: URL) throws {
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error as CocoaError where error.code == .fileNoSuchFile {
            return
        }
    }

    private func fileURL(_ noteID: UUID, format: String) -> URL {
        directory.appendingPathComponent(noteID.uuidString).appendingPathExtension(format)
    }
}
