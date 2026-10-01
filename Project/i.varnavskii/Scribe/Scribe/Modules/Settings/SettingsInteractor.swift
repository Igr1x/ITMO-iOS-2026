//
//  SettingsInteractor.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class SettingsInteractor {
    
    private let userDetailsRepo: UserDetailsRepository
    private let subjectRepo: SubjectRepository
    
    init(
        userDetailsRepo: UserDetailsRepository,
        subjectRepo: SubjectRepository
    ) {
        self.userDetailsRepo = userDetailsRepo
        self.subjectRepo = subjectRepo
    }
    
    func getSettings() -> HomePageSettings {
        return userDetailsRepo.getHomePageSettings()
    }
    
    func saveSettings(_ settings: HomePageSettings) {
        userDetailsRepo.saveHomePageSettings(settings)
    }
    
    func getSubjects() -> [Subject] {
        return subjectRepo.getAll().sorted { $0.title < $1.title }
    }
}
