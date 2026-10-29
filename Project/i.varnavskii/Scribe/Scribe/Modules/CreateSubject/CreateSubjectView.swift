//
//  CreateSubjectView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

struct CreateSubjectView: View {

    @State private var title: String = ""

    let presenter: CreateSubjectPresenter

    var body: some View {
        VStack(spacing: 20) {

            TextField("Название предмета", text: $title)
                .textFieldStyle(.roundedBorder)

            Button("Сохранить") {
                presenter.createSubject(title: title)
            }
            .buttonStyle(.borderedProminent)
            .disabled(title.isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle("Новый предмет")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presenter.back()
                } label: {
                    Image(systemName: "chevron.left")
                    Text("Назад")
                }
            }
        }
    }
}
