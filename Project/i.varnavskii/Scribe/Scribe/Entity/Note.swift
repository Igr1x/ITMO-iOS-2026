//
//  Note.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation

struct Note: Sendable {
    let id: UUID
    var title: String
    var subjectId: UUID
    var createdAt: Int
}
