//
//  SwiftDataSubjectRepository.swift
//  Scribe
//

import Foundation
import SwiftData

final class SwiftDataSubjectRepository: SubjectRepository {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ subject: Subject) {
        let subjectId = subject.id
        let descriptor = FetchDescriptor<SubjectModel>(
            predicate: #Predicate { $0.id == subjectId }
        )

        if let existing = try? context.fetch(descriptor).first {
            existing.title = subject.title
        } else {
            context.insert(SubjectModel(subject: subject))
        }

        try? context.save()
    }

    func getAll() -> [Subject] {
        let descriptor = FetchDescriptor<SubjectModel>(
            sortBy: [SortDescriptor(\.title)]
        )

        let models = (try? context.fetch(descriptor)) ?? []
        return models.map { $0.entity }
    }

    func delete(_ title: String) {
        let descriptor = FetchDescriptor<SubjectModel>(
            predicate: #Predicate { $0.title == title }
        )

        guard let models = try? context.fetch(descriptor) else {
            return
        }

        models.forEach { context.delete($0) }
        try? context.save()
    }
}