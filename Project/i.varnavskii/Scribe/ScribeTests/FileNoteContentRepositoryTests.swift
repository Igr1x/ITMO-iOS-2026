//
//  FileNoteContentRepositoryTests.swift
//  ScribeTests
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

import Foundation
import XCTest
@testable import Scribe

final class FileNoteContentRepositoryTests: XCTestCase {
    private var directory: URL!
    private var repository: FileNoteContentRepository!

    override func setUpWithError() throws {
        directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        repository = FileNoteContentRepository(directory: directory)
    }

    override func tearDownWithError() throws {
        if FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.removeItem(at: directory)
        }
        repository = nil
        directory = nil
    }

    func testMissingFileReturnsEmptyText() async throws {
        let text = try await repository.load(noteID: UUID())
        XCTAssertEqual(text, "")
    }

    func testSavedTextSurvivesNewRepositoryInstance() async throws {
        let noteID = UUID()
        let text = "Лекция по Swift\nПервая строка 📝"
        try await repository.save(text, noteID: noteID)

        let reopened = FileNoteContentRepository(directory: directory)
        let loaded = try await reopened.load(noteID: noteID)
        XCTAssertEqual(loaded, text)
    }

    func testSaveOverwritesExistingFile() async throws {
        let noteID = UUID()
        try await repository.save("Первый вариант", noteID: noteID)
        try await repository.save("Исправленный вариант", noteID: noteID)

        let loaded = try await repository.load(noteID: noteID)
        XCTAssertEqual(loaded, "Исправленный вариант")
        let files = try FileManager.default.contentsOfDirectory(atPath: directory.path)
        XCTAssertEqual(files, [noteID.uuidString + ".md"])
    }

    func testDeleteRemovesOnlySelectedFiles() async throws {
        let firstID = UUID()
        let secondID = UUID()
        try await repository.save("Первый конспект", noteID: firstID)
        try await repository.save("Второй конспект", noteID: secondID)
        try await repository.delete(noteIDs: [firstID, UUID()])

        let deleted = try await repository.load(noteID: firstID)
        let remaining = try await repository.load(noteID: secondID)
        XCTAssertEqual(deleted, "")
        XCTAssertEqual(remaining, "Второй конспект")
    }

    func testInvalidUTF8IsReportedAsError() async throws {
        let noteID = UUID()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let file = directory.appendingPathComponent(noteID.uuidString).appendingPathExtension("md")
        try Data([0xFF, 0xFF]).write(to: file)

        do {
            _ = try await repository.load(noteID: noteID)
            XCTFail("Повреждённый файл нельзя считать пустым конспектом")
        } catch {
            XCTAssertTrue(error is CocoaError)
        }
    }

    func testLegacyTextFileIsStillReadable() async throws {
        let noteID = UUID()
        let legacy = try writeFile(Data("Старый конспект".utf8), noteID: noteID, format: "txt")

        let loaded = try await repository.load(noteID: noteID)

        XCTAssertEqual(loaded, "Старый конспект")
        XCTAssertTrue(FileManager.default.fileExists(atPath: legacy.path))
    }

    func testSaveMigratesLegacyFileAfterWritingMarkdown() async throws {
        let noteID = UUID()
        let legacy = try writeFile(Data("Старый текст".utf8), noteID: noteID, format: "txt")

        try await repository.save("# Обновлённый конспект", noteID: noteID)

        let markdown = directory.appendingPathComponent(noteID.uuidString).appendingPathExtension("md")
        XCTAssertEqual(try String(contentsOf: markdown, encoding: .utf8), "# Обновлённый конспект")
        XCTAssertFalse(FileManager.default.fileExists(atPath: legacy.path))
    }

    func testEmptyMarkdownTakesPriorityOverLegacyText() async throws {
        let noteID = UUID()
        _ = try writeFile(Data("Старый текст".utf8), noteID: noteID, format: "txt")
        _ = try writeFile(Data(), noteID: noteID, format: "md")

        let loaded = try await repository.load(noteID: noteID)

        XCTAssertEqual(loaded, "")
    }

    func testInvalidMarkdownDoesNotFallBackToLegacyFile() async throws {
        let noteID = UUID()
        _ = try writeFile(Data("Старый текст".utf8), noteID: noteID, format: "txt")
        _ = try writeFile(Data([0xFF, 0xFF]), noteID: noteID, format: "md")

        do {
            _ = try await repository.load(noteID: noteID)
            XCTFail("Ошибка чтения Markdown не должна скрываться старым текстом")
        } catch {
            XCTAssertTrue(error is CocoaError)
        }
    }

    func testFailedMigrationPreservesLegacyFile() async throws {
        let noteID = UUID()
        let legacy = try writeFile(Data("Старый текст".utf8), noteID: noteID, format: "txt")
        let markdown = directory.appendingPathComponent(noteID.uuidString).appendingPathExtension("md")
        // Директория вместо файла заставляет запись завершиться ошибкой.
        try FileManager.default.createDirectory(at: markdown, withIntermediateDirectories: true)

        do {
            try await repository.save("Новый текст", noteID: noteID)
            XCTFail("Ожидалась ошибка записи")
        } catch {
            XCTAssertEqual(try String(contentsOf: legacy, encoding: .utf8), "Старый текст")
        }
    }

    func testDeleteRemovesMarkdownAndLegacyFiles() async throws {
        let noteID = UUID()
        let legacy = try writeFile(Data("Старый текст".utf8), noteID: noteID, format: "txt")
        let markdown = try writeFile(Data("# Новый текст".utf8), noteID: noteID, format: "md")

        try await repository.delete(noteIDs: [noteID])

        XCTAssertFalse(FileManager.default.fileExists(atPath: legacy.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: markdown.path))
    }

    private func writeFile(_ data: Data, noteID: UUID, format: String) throws -> URL {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent(noteID.uuidString).appendingPathExtension(format)
        try data.write(to: url)
        return url
    }

}
