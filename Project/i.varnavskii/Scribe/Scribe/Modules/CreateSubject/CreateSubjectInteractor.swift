//
//  CreateSubjectInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation

final class CreateSubjectInteractor {

    private let subjectRepo: SubjectRepository

    init(subjectRepo: SubjectRepository) {
        self.subjectRepo = subjectRepo
    }

    func saveSubject(title: String) {
        subjectRepo.save(
            Subject(
                id: UUID(),
                title: title
            )
        )

    }
}
