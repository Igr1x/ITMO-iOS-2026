//
//  NotesSearchWorkerTests.swift
//  ScribeTests
//
//  Created by Варнавский Игорь Витальевич on 11.11.2026.
//

import Foundation
import XCTest
@testable import Scribe

@MainActor
final class NotesSearchWorkerTests: XCTestCase {
    private var worker: NotesSearchWorker!
    private var subject: Subject!
    private var olderNote: Note!
    private var newerNote: Note!

    override func setUp() async throws {
        try await super.setUp()
        worker = NotesSearchWorker()
        subject = Subject(id: UUID(), title: "Swift")
        olderNote = Note(id: UUID(), title: "Основы Swift", subjectId: subject.id, createdAt: 100)
        newerNote = Note(id: UUID(), title: "Конкурентность", subjectId: subject.id, createdAt: 200)
    }

    override func tearDown() async throws {
        worker = nil
        subject = nil
        olderNote = nil
        newerNote = nil
        try await super.tearDown()
    }

    func testSearchIgnoresCaseAndSurroundingSpaces() async throws {
        let groups = try await worker.search(
            notes: [olderNote, newerNote], subjects: [subject], query: "  SWIFT  "
        )

        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups.first?.title, "Swift")
        XCTAssertEqual(groups.first?.notes.map(\.id), [olderNote.id])
    }

    func testEmptyQueryReturnsNewestNotesFirst() async throws {
        let groups = try await worker.search(
            notes: [olderNote, newerNote], subjects: [subject], query: ""
        )

        XCTAssertEqual(groups.first?.notes.map(\.id), [newerNote.id, olderNote.id])
    }

    func testUnknownQueryReturnsNoGroups() async throws {
        let groups = try await worker.search(
            notes: [olderNote, newerNote], subjects: [subject], query: "Kotlin"
        )

        XCTAssertTrue(groups.isEmpty)
    }
}
