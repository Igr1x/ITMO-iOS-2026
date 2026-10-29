//
//  SubjectModel.swift
//  Scribe
//

import Foundation
import SwiftData

@Model
final class SubjectModel {
    @Attribute(.unique) var id: UUID
    var title: String

    init(
        id: UUID,
        title: String
    ) {
        self.id = id
        self.title = title
    }

    convenience init(subject: Subject) {
        self.init(
            id: subject.id,
            title: subject.title
        )
    }

    var entity: Subject {
        Subject(
            id: id,
            title: title
        )
    }
}
