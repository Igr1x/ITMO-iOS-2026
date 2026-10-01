//
//  Untitled.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

struct HomePageView: View {
    
    let presenter: HomePagePresenter
    
    var body: some View {
        List {
            ForEach(presenter.notes, id: \.title) { note in
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
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Конспекты")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    presenter.createNoteButtonTapped()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            presenter.onAppear()
        }
    }
}
