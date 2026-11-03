//
//  EditNoteView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

import SwiftUI

struct EditNoteView: View {
    @State var presenter: EditNotePresenter
    @State private var showsPreview = false

    init(presenter: EditNotePresenter) {
        _presenter = State(initialValue: presenter)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Режим", selection: $showsPreview) {
                Text("Редактор").tag(false)
                Text("Просмотр").tag(true)
            }
            .pickerStyle(.segmented)
            .disabled(!presenter.isLoaded || presenter.isSaving)
            .accessibilityIdentifier("noteEditor.mode")

            noteContent
                .overlay {
                    if presenter.isLoading { ProgressView("Загрузка конспекта…") }
                }
            if presenter.isLoaded {
                Text(presenter.hasChanges ? "Есть несохранённые изменения" : "Все изменения сохранены")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("noteEditor.status")
            }
        }
        .padding()
        .navigationTitle(presenter.note.title)
        .navigationBarBackButtonHidden()
        .toolbar { editorToolbar }
        .task { await presenter.load() }
        .confirmationDialog("Сохранить изменения?", isPresented: $presenter.showsUnsavedChanges) {
            Button("Сохранить и выйти") {
                Task { await presenter.save(closeAfterSaving: true) }
            }
            Button("Не сохранять", role: .destructive) { presenter.discardChanges() }
            Button("Продолжить редактирование", role: .cancel) {}
        }
        .alert("Ошибка", isPresented: Binding(
            get: { presenter.errorMessage != nil },
            set: { if !$0 { presenter.errorMessage = nil } }
        )) {
            if !presenter.isLoaded {
                Button("Повторить") { Task { await presenter.load() } }
            }
            Button("Закрыть", role: .cancel) { presenter.errorMessage = nil }
        } message: { Text(presenter.errorMessage ?? "") }
    }

    @ViewBuilder
    private var noteContent: some View {
        if showsPreview {
            MarkdownPreviewView(text: presenter.text)
        } else {
            TextEditor(text: $presenter.text)
                .font(.body)
                .accessibilityLabel("Текст конспекта в Markdown")
                .accessibilityIdentifier("noteEditor.text")
                .disabled(!presenter.isLoaded || presenter.isSaving)
        }
    }

    @ToolbarContentBuilder
    private var editorToolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Назад", systemImage: "chevron.left") { presenter.backButtonTapped() }
                .disabled(presenter.isSaving)
        }
        ToolbarItem(placement: .primaryAction) {
            Button(presenter.isSaving ? "Сохранение…" : "Сохранить") {
                Task { await presenter.save() }
            }
            .disabled(!presenter.canSave)
            .accessibilityIdentifier("noteEditor.save")
        }
    }
}
