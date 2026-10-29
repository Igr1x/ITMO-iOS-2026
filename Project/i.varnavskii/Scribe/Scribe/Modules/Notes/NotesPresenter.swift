//
//  NotesPresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation
import Observation

struct NotesGroup: Identifiable, Sendable {
    let id: UUID
    let title: String
    var notes: [Note]
}

@Observable
final class NotesPresenter {

    private let interactor: NotesInteractor
    private let notesSearchWorker: NotesSearchWorker

    var query: String = ""
    var groups: [NotesGroup] = []
    var collapsedGroupIds: Set<UUID> = []

    var isSelectionMode: Bool = false
    var selectedNoteIds: Set<UUID> = []

    private var allNotes: [Note] = []
    private var allSubjects: [Subject] = []

    @ObservationIgnored
    private var searchTask: Task<Void, Never>?

    @ObservationIgnored
    private var searchTaskVersion: Int = 0

    init(
        interactor: NotesInteractor,
        notesSearchWorker: NotesSearchWorker
    ) {
        self.interactor = interactor
        self.notesSearchWorker = notesSearchWorker
    }

    func onAppear() {
        allNotes = interactor.getNotes()
        allSubjects = interactor.getSubjects()
        startSearch()
    }

    func cancelSearch() {
        searchTask?.cancel()
        searchTask = nil
        searchTaskVersion += 1
    }

    func setQuery(_ value: String) {
        query = value
        startSearch()
    }

    func toggleCollapse(_ groupId: UUID) {
        if collapsedGroupIds.contains(groupId) {
            collapsedGroupIds.remove(groupId)
        } else {
            collapsedGroupIds.insert(groupId)
        }
    }

    func isCollapsed(_ groupId: UUID) -> Bool {
        return collapsedGroupIds.contains(groupId)
    }

    func toggleSelectionMode() {
        isSelectionMode.toggle()
        if !isSelectionMode {
            selectedNoteIds.removeAll()
        }
    }

    func toggleNoteSelection(_ noteId: UUID) {
        if selectedNoteIds.contains(noteId) {
            selectedNoteIds.remove(noteId)
        } else {
            selectedNoteIds.insert(noteId)
        }
    }

    func deleteSelected() {
        let ids = Array(selectedNoteIds)
        guard !ids.isEmpty else {
            return
        }
        interactor.deleteNotes(ids: ids)
        selectedNoteIds.removeAll()
        isSelectionMode = false
        onAppear()
    }

    private func startSearch() {
        searchTask?.cancel()
        searchTaskVersion += 1
        let currentVersion = searchTaskVersion
        let currentNotes = allNotes
        let currentSubj = allSubjects
        let currentQuery = query

        searchTask = Task {
            do {
                let result = try await notesSearchWorker.search(
                    notes: currentNotes,
                    subjects: currentSubj,
                    query: currentQuery
                )

                try Task.checkCancellation()
                guard currentVersion == searchTaskVersion else {
                    return
                }
                groups = result
            } catch is CancellationError {
            } catch {
            }
        }
    }
}
