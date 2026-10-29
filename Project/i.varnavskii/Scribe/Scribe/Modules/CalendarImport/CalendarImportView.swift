//
//  CalendarImportView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import SwiftUI

struct CalendarImportView: View {
    @State private var presenter: CalendarImportPresenter
    private let onImported: (Date?) -> Void
    @Environment(\.dismiss) private var dismiss

    init(presenter: CalendarImportPresenter, onImported: @escaping (Date?) -> Void) {
        _presenter = State(initialValue: presenter)
        self.onImported = onImported
    }

    var body: some View {
        Form {
            if let result = presenter.result {
                Section {
                    Label("Импорт завершён", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.headline)
                    LabeledContent("Добавлено", value: "\(result.inserted)")
                    LabeledContent("Обновлено", value: "\(result.updated)")
                    Text("События сохранены и доступны без интернета.")
                    Button("Открыть календарь", action: finish)
                }
            } else {
                sourceSection
                periodSection
                if let message = presenter.errorMessage {
                    Section {
                        Label(message, systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                    }
                }
                Section {
                    if presenter.isLoading {
                        HStack {
                            ProgressView()
                            Text("Загружаем события…")
                        }
                        Button("Отменить загрузку", role: .cancel) { presenter.cancel() }
                    } else {
                        Button(presenter.preview == nil ? "Загрузить события" : "Загрузить заново") {
                            presenter.download()
                        }
                        .disabled(!presenter.canDownload)
                        .accessibilityIdentifier("calendarImport.download")
                    }
                }
                if let preview = presenter.preview {
                    previewSection(preview)
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Импорт календаря")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(presenter.result == nil ? "Закрыть" : "Готово") {
                    finish()
                }
                .accessibilityIdentifier("calendarImport.close")
            }
        }
        .onChange(of: presenter.link) { _, _ in
            if presenter.result == nil { presenter.invalidatePreview() }
        }
        .onChange(of: presenter.startDate) { _, _ in presenter.invalidatePreview() }
        .onChange(of: presenter.endDate) { _, _ in presenter.invalidatePreview() }
        .onDisappear { presenter.cancel() }
    }

    private func finish() {
        if presenter.result != nil {
            onImported(presenter.firstImportedDate)
        }
        dismiss()
    }

    private var sourceSection: some View {
        Section {
            TextField("https://calendar.google.com/calendar/ical/…", text: $presenter.link, axis: .vertical)
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
                .autocorrectionDisabled()
                .privacySensitive()
                .accessibilityLabel("Ссылка iCal из Google Calendar")
                .accessibilityIdentifier("calendarImport.link")
        } header: {
            Text("Ссылка iCal")
        }
    }

    private var periodSection: some View {
        Section {
            DatePicker("С", selection: $presenter.startDate, displayedComponents: .date)
            DatePicker("По", selection: $presenter.endDate, in: presenter.startDate..., displayedComponents: .date)
        } header: {
            Text("Период импорта")
        }
    }

    private func previewSection(_ preview: CalendarImportPreview) -> some View {
        Section {
            LabeledContent("Календарь", value: preview.calendarName)
            LabeledContent("Найдено событий", value: "\(preview.events.count)")
            if preview.skippedEvents > 0 {
                Label("Пропущено записей: \(preview.skippedEvents). Повторы и некоторые форматы событий пока не поддерживаются.",
                      systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.orange)
            }
            if preview.events.isEmpty {
                Text("Нет подходящих событий. Проверьте период импорта или выберите другой календарь.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(preview.events.prefix(5)) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                        Text(event.startDate, format: .dateTime.day().month().year())
                            .foregroundStyle(.secondary)
                        CalendarEventTimeView(start: event.startDate, end: event.endDate, isAllDay: event.isAllDay)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                if preview.events.count > 5 {
                    Text("И ещё \(preview.events.count - 5)…").foregroundStyle(.secondary)
                }
                Button("Импортировать событий: \(preview.events.count)") { presenter.save() }
                    .buttonStyle(.borderedProminent)
            }
        } header: {
            Text("Результат загрузки")
        }
    }
}
