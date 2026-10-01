//
//  NotesPresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation
import Observation

struct NotesGroup: Identifiable {
    let id: UUID
    let title: String
    var notes: [Note]
}

@Observable
final class NotesPresenter {
    
    private let interactor: NotesInteractor
    
    var query: String = ""
    var groups: [NotesGroup] = []
    var collapsedGroupIds: Set<UUID> = []
    
    var isSelectionMode: Bool = false
    var selectedNoteIds: Set<UUID> = []
    
    private var allNotes: [Note] = []
    private var allSubjects: [Subject] = []
    
    init(interactor: NotesInteractor) {
        self.interactor = interactor
    }
    
    func onAppear() {
        allNotes = interactor.getNotes()
        allSubjects = interactor.getSubjects()
        rebuild()
    }
    
    func setQuery(_ value: String) {
        query = value
        rebuild()
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
    
    private func rebuild() {
        let subjectsById = Dictionary(
            uniqueKeysWithValues: allSubjects.map { ($0.id, $0) }
        )
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered = trimmed.isEmpty
            ? allNotes
            : allNotes.filter {
                $0.title.localizedCaseInsensitiveContains(trimmed)
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
        groups = result
    }
}
