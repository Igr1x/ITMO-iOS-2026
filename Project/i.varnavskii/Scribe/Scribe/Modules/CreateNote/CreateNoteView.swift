//
//  CreateNoteView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

struct CreateNoteView: View {
    @State private var title: String = ""

    @State var presenter: CreateNotePresenter

    var body: some View {
        VStack(spacing: 20) {

            TextField("Название конспекта", text: $title)
                .textFieldStyle(.roundedBorder)

            Menu {
                ForEach(presenter.subjects, id: \.id) { subject in
                    Button {
                        presenter.selectSubject(subject)
                    } label: {
                        if subject.id == presenter.selectedSubject?.id {
                            Label(subject.title, systemImage: "checkmark")
                        } else {
                            Text(subject.title)
                        }
                    }
                }

                Divider()

                Button("Создать новый предмет") {
                    presenter.createSubjTapped()
                }
            } label: {
                HStack {
                    Text(presenter.selectedSubject?.title ?? "Выберите предмет")
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Button("Создать") {
                presenter.saveButtonTapped(title: title)
            }
            .buttonStyle(.borderedProminent)
            .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || presenter.selectedSubject == nil)

            Spacer()
        }
        .padding()
        .navigationTitle("Новый конспект")
        .alert("Ошибка", isPresented: Binding(
            get: { presenter.errorMessage != nil },
            set: { if !$0 { presenter.errorMessage = nil } }
        )) {
            Button("Закрыть", role: .cancel) { presenter.errorMessage = nil }
        } message: { Text(presenter.errorMessage ?? "") }
        .navigationBarBackButtonHidden()
        .onAppear {
            presenter.onAppear()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presenter.backButtonTapped()
                } label: {
                    Image(systemName: "chevron.left")
                    Text("Назад")
                }
            }
        }
    }
}
