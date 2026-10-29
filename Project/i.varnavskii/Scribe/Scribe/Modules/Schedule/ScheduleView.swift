//
//  ScheduleView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import SwiftUI

struct ScheduleView: View {
    @State private var presenter: SchedulePresenter
    @State private var isImportPresented = false
    private let makeImportView: (@escaping (Date?) -> Void) -> CalendarImportView

    init(
        presenter: SchedulePresenter,
        makeImportView: @escaping (@escaping (Date?) -> Void) -> CalendarImportView
    ) {
        _presenter = State(initialValue: presenter)
        self.makeImportView = makeImportView
    }

    var body: some View {
        List {
            Section {
                DatePicker("Дата", selection: $presenter.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                Button("Сегодня") { presenter.selectedDate = Date() }
            }
            Section {
                if presenter.eventsForSelectedDay.isEmpty {
                    ContentUnavailableView {
                        Label("Нет событий", systemImage: "calendar")
                    } description: {
                        Text(presenter.events.isEmpty
                             ? "Импортируйте события из Google Calendar, чтобы увидеть их здесь."
                             : "На выбранную дату событий нет. Выберите другой день.")
                    } actions: {
                        if presenter.events.isEmpty {
                            Button("Импортировать календарь", action: openImport)
                        }
                    }
                } else {
                    ForEach(presenter.eventsForSelectedDay, id: \.id) { event in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(event.title).font(.headline)
                            CalendarEventTimeView(start: event.startDate, end: event.endDate, isAllDay: event.isAllDay)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            } header: {
                Text(presenter.selectedDate, format: .dateTime.day().month(.wide).year())
            }
        }
        .navigationTitle("Календарь")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Импорт", systemImage: "square.and.arrow.down", action: openImport)
                    .accessibilityIdentifier("calendar.openImport")
            }
        }
        .onAppear { presenter.reload() }
        .sheet(isPresented: $isImportPresented, onDismiss: { presenter.reload() }) {
            NavigationStack {
                makeImportView { firstEventDate in
                    presenter.didImport(firstEventDate: firstEventDate)
                }
            }
        }
        .alert("Ошибка", isPresented: Binding(
            get: { presenter.errorMessage != nil },
            set: { if !$0 { presenter.errorMessage = nil } }
        )) {
            Button("Повторить") { presenter.reload() }
            Button("Закрыть", role: .cancel) { presenter.errorMessage = nil }
        } message: {
            Text(presenter.errorMessage ?? "")
        }
    }

    private func openImport() {
        isImportPresented = true
    }
}

struct CalendarEventTimeView: View {
    let start: Date
    let end: Date
    let isAllDay: Bool

    var body: some View {
        if isAllDay {
            let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: end) ?? start
            if Calendar.current.isDate(start, inSameDayAs: lastDay) {
                Text("Весь день")
            } else {
                let startLabel = start.formatted(date: .abbreviated, time: .omitted)
                let lastDayLabel = lastDay.formatted(date: .abbreviated, time: .omitted)
                Text("Весь день · \(startLabel) — \(lastDayLabel)")
            }
        } else if Calendar.current.isDate(start, inSameDayAs: end) {
            let startLabel = start.formatted(date: .omitted, time: .shortened)
            let endLabel = end.formatted(date: .omitted, time: .shortened)
            Text("\(startLabel) — \(endLabel)")
        } else {
            let startLabel = start.formatted(date: .abbreviated, time: .shortened)
            let endLabel = end.formatted(date: .abbreviated, time: .shortened)
            Text("\(startLabel) — \(endLabel)")
        }
    }
}
