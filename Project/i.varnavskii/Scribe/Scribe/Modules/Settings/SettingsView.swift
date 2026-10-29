//
//  SettingsView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

struct SettingsView: View {

    let presenter: SettingsPresenter

    var body: some View {
        Form {
            Section("Конспекты на главной") {
                Stepper(
                    "Показывать: \(presenter.notesLimit)",
                    value: Binding(
                        get: { presenter.notesLimit },
                        set: { presenter.notesLimit = $0 }
                    ),
                    in: 1...presenter.maxNotesLimit
                )
            }

            Section("Предмет") {
                Menu {
                    Button {
                        presenter.selectSubject(nil)
                    } label: {
                        if presenter.selectedSubjectId == nil {
                            Label("Все предметы", systemImage: "checkmark")
                        } else {
                            Text("Все предметы")
                        }
                    }

                    ForEach(presenter.subjects, id: \.id) { subject in
                        Button {
                            presenter.selectSubject(subject)
                        } label: {
                            if subject.id == presenter.selectedSubjectId {
                                Label(subject.title, systemImage: "checkmark")
                            } else {
                                Text(subject.title)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedSubjectTitle)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Button("Сохранить") {
                    presenter.save()
                }
            }
        }
        .navigationTitle("Настройки")
        .onAppear {
            presenter.onAppear()
        }
    }

    private var selectedSubjectTitle: String {
        guard let id = presenter.selectedSubjectId,
              let subject = presenter.subjects.first(where: { $0.id == id })
        else {
            return "Все предметы"
        }
        return subject.title
    }
}
