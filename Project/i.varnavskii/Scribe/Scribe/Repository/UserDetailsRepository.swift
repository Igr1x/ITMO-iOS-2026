//
//  UserDetailsRepository.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Foundation

struct HomePageSettings {
    var notesLimit: Int
    var subjectId: UUID?
}

protocol UserDetailsRepository {
    func getHomePageSettings() -> HomePageSettings
    func saveHomePageSettings(_ settings: HomePageSettings)
}

final class UserDefaultsUserDetailsRepository: UserDetailsRepository {

    private enum Keys {
        static let notesLimit = "home.notesLimit"
        static let subjectId = "home.subjectId"
    }

    static let maxNotesLimit = 10
    static let defaultNotesLimit = 5

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func getHomePageSettings() -> HomePageSettings {
        let limit = defaults.object(forKey: Keys.notesLimit) as? Int
            ?? Self.defaultNotesLimit

        let subjectId = defaults.string(forKey: Keys.subjectId)
            .flatMap(UUID.init(uuidString:))

        return HomePageSettings(
            notesLimit: min(max(limit, 1), Self.maxNotesLimit),
            subjectId: subjectId
        )
    }

    func saveHomePageSettings(_ settings: HomePageSettings) {
        let limit = min(max(settings.notesLimit, 1), Self.maxNotesLimit)
        defaults.set(limit, forKey: Keys.notesLimit)

        if let subjectId = settings.subjectId {
            defaults.set(subjectId.uuidString, forKey: Keys.subjectId)
        } else {
            defaults.removeObject(forKey: Keys.subjectId)
        }
    }
}
