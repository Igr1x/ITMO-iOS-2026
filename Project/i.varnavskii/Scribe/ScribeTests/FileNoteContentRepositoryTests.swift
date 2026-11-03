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
        XCTAssertEqual(files, [noteID.uuidString + ".txt"])
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
        let file = directory.appendingPathComponent(noteID.uuidString).appendingPathExtension("txt")
        try Data([0xFF, 0xFF]).write(to: file)

        do {
            _ = try await repository.load(noteID: noteID)
            XCTFail("Повреждённый файл нельзя считать пустым конспектом")
        } catch {
            XCTAssertTrue(error is CocoaError)
        }
    }
}
