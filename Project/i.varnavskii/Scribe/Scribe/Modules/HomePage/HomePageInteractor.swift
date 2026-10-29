//
//  HomePageInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation

final class HomePageInteractor {
    private let notesRepo: NotesRepository
    private let userDetailsRepo: UserDetailsRepository
    private let subjectRepo: SubjectRepository

    init(
        notesRepo: NotesRepository,
        userDetailsRepo: UserDetailsRepository,
        subjectRepo: SubjectRepository
    ) {
        self.notesRepo = notesRepo
        self.userDetailsRepo = userDetailsRepo
        self.subjectRepo = subjectRepo
    }

    func getSettings() -> HomePageSettings {
        return userDetailsRepo.getHomePageSettings()
    }

    func getSubject(id: UUID) -> Subject? {
        return subjectRepo.getAll().first { $0.id == id }
    }

    func getNotes(limit: Int, offset: Int = 0) -> [Note] {
        return notesRepo.getNotes(limit: limit, offset: offset)
    }
}
