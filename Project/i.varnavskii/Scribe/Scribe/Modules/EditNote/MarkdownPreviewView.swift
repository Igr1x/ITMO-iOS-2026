//
//  MarkdownPreviewView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

import SwiftUI
import Textual

struct MarkdownPreviewView: View {
    let text: String

    var body: some View {
        ScrollView {
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ContentUnavailableView(
                    "Нет текста для просмотра",
                    systemImage: "doc.text",
                    description: Text("Напишите конспект во вкладке «Редактор».")
                )
            } else {
                StructuredText(markdown: text)
                    .textual.structuredTextStyle(.gitHub)
                    .textual.textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("noteEditor.preview")
    }
}
