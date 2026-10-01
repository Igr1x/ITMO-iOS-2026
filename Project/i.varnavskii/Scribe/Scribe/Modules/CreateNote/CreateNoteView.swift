//
//  CreateNoteView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

struct CreateNoteView: View {
    @State private var title: String = ""

    let presenter: CreateNotePresenter

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

            Button("Сохранить") {
                presenter.saveButtonTapped(title: title)
                title = ""
            }
            .buttonStyle(.borderedProminent)
            .disabled(title.isEmpty || presenter.selectedSubject == nil)

            Spacer()
        }
        .padding()
        .navigationTitle("Новый конспект")
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
