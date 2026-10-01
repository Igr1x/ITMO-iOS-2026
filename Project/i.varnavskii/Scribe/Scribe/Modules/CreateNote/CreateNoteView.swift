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
            Text("Создание конспекта")
                .font(.title)
                .fontWeight(.bold)

            TextField("Название конспекта", text: $title)
                .textFieldStyle(.roundedBorder)

            Button("Сохранить") {
                presenter.saveButtonTapped(title: title)
                title = ""
            }
            .buttonStyle(.borderedProminent)
            .disabled(title.isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle("Новый конспект")
        .navigationBarBackButtonHidden()
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
