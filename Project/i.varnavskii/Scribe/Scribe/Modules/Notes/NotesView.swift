//
//  NotesView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

struct NotesView: View {
    
    let presenter: NotesPresenter
    let onCreateNote: () -> Void
    
    var body: some View {
        List {
            ForEach(presenter.groups) { group in
                Section {
                    if !presenter.isCollapsed(group.id) {
                        ForEach(group.notes, id: \.id) { note in
                            row(for: note)
                        }
                    }
                } header: {
                    header(for: group)
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: searchBinding, prompt: "Поиск конспекта")
        .navigationTitle("Конспекты")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if presenter.isSelectionMode {
                    Button("Отмена") {
                        presenter.toggleSelectionMode()
                    }
                } else {
                    Button("Выбрать") {
                        presenter.toggleSelectionMode()
                    }
                    .disabled(presenter.groups.isEmpty)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if presenter.isSelectionMode {
                    Button(role: .destructive) {
                        presenter.deleteSelected()
                    } label: {
                        Text("Удалить (\(presenter.selectedNoteIds.count))")
                    }
                    .disabled(presenter.selectedNoteIds.isEmpty)
                } else {
                    Button {
                        onCreateNote()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            presenter.onAppear()
        }
    }
    
    private var searchBinding: Binding<String> {
        Binding(
            get: { presenter.query },
            set: { presenter.setQuery($0) }
        )
    }
    
    @ViewBuilder
    private func header(for group: NotesGroup) -> some View {
        Button {
            presenter.toggleCollapse(group.id)
        } label: {
            HStack {
                Image(
                    systemName: presenter.isCollapsed(group.id)
                        ? "chevron.right"
                        : "chevron.down"
                )
                .font(.caption)
                Text(group.title)
                Spacer()
                Text("\(group.notes.count)")
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func row(for note: Note) -> some View {
        HStack {
            if presenter.isSelectionMode {
                Image(
                    systemName: presenter.selectedNoteIds.contains(note.id)
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .foregroundStyle(.tint)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(.headline)
                Text(
                    Date(
                        timeIntervalSince1970: TimeInterval(note.createdAt)
                    ),
                    format: .dateTime
                        .day()
                        .month()
                        .year()
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if presenter.isSelectionMode {
                presenter.toggleNoteSelection(note.id)
            }
        }
    }
}
