//
//  CalendarImportPresenter.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 15.10.2026.
//

import Foundation
import Observation

@Observable
final class CalendarImportPresenter {
    private let interactor: CalendarImportInteractor

    var link = ""
    var startDate = Calendar.current.startOfDay(for: Date())
    var endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    var isLoading = false
    var preview: CalendarImportPreview?
    var errorMessage: String?
    var result: CalendarImportResult?
    private(set) var firstImportedDate: Date?

    @ObservationIgnored private var task: Task<Void, Never>?
    @ObservationIgnored private var requestVersion = 0

    init(interactor: CalendarImportInteractor) {
        self.interactor = interactor
    }

    var canDownload: Bool {
        !isLoading && endDate >= startDate && interactor.isValidLink(link)
    }

    func invalidatePreview() {
        cancel()
        preview = nil
        result = nil
        errorMessage = nil
    }

    func download() {
        cancel()
        preview = nil
        result = nil
        errorMessage = nil
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        guard let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate)), end > start,
              end.timeIntervalSince(start) <= 366 * 86400 * 5 else {
            errorMessage = "Выберите период импорта продолжительностью не более пяти лет."
            return
        }
        let interval = DateInterval(start: start, end: end)
        let currentLink = link
        let version = requestVersion
        isLoading = true
        task = Task {
            do {
                let loaded = try await interactor.loadPreview(link: currentLink, interval: interval)
                try Task.checkCancellation()
                guard version == requestVersion else { return }
                preview = loaded
                isLoading = false
            } catch is CancellationError {
            } catch {
                guard version == requestVersion else { return }
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    func save() {
        guard !isLoading, result == nil, let preview, !preview.events.isEmpty else { return }
        do {
            result = try interactor.save(preview.events)
            firstImportedDate = preview.events.first?.startDate
            // Do not retain the secret address after a successful import.
            link = ""
            errorMessage = nil
        } catch {
            errorMessage = "Не удалось сохранить события. Попробуйте импортировать их ещё раз."
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
        requestVersion += 1
        isLoading = false
    }
}
