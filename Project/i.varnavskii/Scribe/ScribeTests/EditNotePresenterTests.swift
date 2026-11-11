//
//  EditNotePresenterTests.swift
//  ScribeTests
//
//  Created by Варнавский Игорь Витальевич on 11.11.2026.
//

import Foundation
import XCTest
@testable import Scribe

@MainActor
final class EditNotePresenterTests: XCTestCase {
    private var repository: NoteContentRepositoryMock!
    private var router: AppRouter!
    private var presenter: EditNotePresenter!
    private var note: Note!

    override func setUp() async throws {
        try await super.setUp()
        note = Note(id: UUID(), title: "Лекция", subjectId: UUID(), createdAt: 0)
        repository = NoteContentRepositoryMock(text: "Сохранённый текст")
        router = AppRouter()
        router.navigate(to: .editNote(note))
        presenter = EditNotePresenter(
            note: note,
            interactor: EditNoteInteractor(noteID: note.id, repository: repository),
            router: EditNoteRouter(appRouter: router)
        )
    }

    override func tearDown() async throws {
        presenter = nil
        router = nil
        repository = nil
        note = nil
        try await super.tearDown()
    }

    func testLoadShowsSavedText() async {
        await presenter.load()

        XCTAssertEqual(presenter.text, "Сохранённый текст")
        XCTAssertTrue(presenter.isLoaded)
        XCTAssertFalse(presenter.isLoading)
        XCTAssertFalse(presenter.hasChanges)
        XCTAssertFalse(presenter.canSave)
    }

    func testSavePassesTextAndNoteIDToRepository() async {
        await presenter.load()
        presenter.text = "# Новая лекция"
        XCTAssertTrue(presenter.canSave)

        await presenter.save()

        let savedText = await repository.savedText
        let savedNoteID = await repository.savedNoteID
        XCTAssertEqual(savedText, "# Новая лекция")
        XCTAssertEqual(savedNoteID, note.id)
        XCTAssertFalse(presenter.hasChanges)
        XCTAssertFalse(presenter.canSave)
        XCTAssertFalse(presenter.isSaving)
        XCTAssertNil(presenter.errorMessage)
    }

    func testFailedSaveKeepsChangesAndShowsError() async {
        await presenter.load()
        presenter.text = "Не потерять этот текст"
        await repository.failNextSave()

        await presenter.save(closeAfterSaving: true)

        XCTAssertNotNil(presenter.errorMessage)
        XCTAssertTrue(presenter.hasChanges)
        XCTAssertTrue(presenter.canSave)
        XCTAssertFalse(presenter.isSaving)
        XCTAssertEqual(router.path, [.editNote(note)])
    }

    func testBackWithChangesAsksForConfirmation() async {
        await presenter.load()
        presenter.text = "Изменения"

        presenter.backButtonTapped()

        XCTAssertTrue(presenter.showsUnsavedChanges)
        XCTAssertEqual(router.path, [.editNote(note)])
    }

    func testBackWithoutChangesClosesEditor() async {
        await presenter.load()

        presenter.backButtonTapped()

        XCTAssertTrue(router.path.isEmpty)
        XCTAssertFalse(presenter.showsUnsavedChanges)
    }

    func testSaveAndExitClosesEditor() async {
        await presenter.load()
        presenter.text = "Готово"

        await presenter.save(closeAfterSaving: true)

        XCTAssertTrue(router.path.isEmpty)
        XCTAssertFalse(presenter.hasChanges)
    }
}

private actor NoteContentRepositoryMock: NoteContentRepository {
    private let text: String
    private var shouldFailSave = false
    private(set) var savedText: String?
    private(set) var savedNoteID: UUID?

    init(text: String) {
        self.text = text
    }

    func load(noteID: UUID) async throws -> String {
        text
    }

    func save(_ text: String, noteID: UUID) async throws {
        if shouldFailSave { throw CocoaError(.fileWriteUnknown) }
        savedText = text
        savedNoteID = noteID
    }

    func delete(noteIDs: [UUID]) async throws {}

    func failNextSave() {
        shouldFailSave = true
    }
}
