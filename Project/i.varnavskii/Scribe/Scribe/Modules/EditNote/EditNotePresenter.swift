//
//  EditNotePresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

import Foundation
import Observation

@Observable
final class EditNotePresenter {
    let note: Note
    private let interactor: EditNoteInteractor
    private let router: EditNoteRouter
    private var savedText = ""

    var text = ""
    var isLoading = true
    var isLoaded = false
    var isSaving = false
    var showsUnsavedChanges = false
    var errorMessage: String?

    init(note: Note, interactor: EditNoteInteractor, router: EditNoteRouter) {
        self.note = note
        self.interactor = interactor
        self.router = router
    }

    var hasChanges: Bool { text != savedText }
    var canSave: Bool { isLoaded && hasChanges && !isSaving }

    func load() async {
        guard !isLoaded else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let loaded = try await interactor.loadText()
            try Task.checkCancellation()
            text = loaded
            savedText = loaded
            isLoaded = true
            errorMessage = nil
        } catch is CancellationError {
            // SwiftUI отменяет загрузку при уходе с экрана.
        } catch {
            errorMessage = "Не удалось открыть конспект: \(error.localizedDescription)"
        }
    }

    func save(closeAfterSaving: Bool = false) async {
        guard isLoaded && !isSaving else { return }
        isSaving = true
        defer { isSaving = false }
        let snapshot = text
        do {
            try await interactor.saveText(snapshot)
            savedText = snapshot
            errorMessage = nil
            if closeAfterSaving { router.back() }
        } catch {
            errorMessage = "Не удалось сохранить конспект: \(error.localizedDescription)"
        }
    }

    func backButtonTapped() {
        guard !isSaving else { return }
        if hasChanges { showsUnsavedChanges = true }
        else { router.back() }
    }

    func discardChanges() {
        router.back()
    }
}
