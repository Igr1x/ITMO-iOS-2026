//
//  SettingsAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class SettingsAsm {

    static func build(
        userDetailsRepo: UserDetailsRepository,
        subjectRepo: SubjectRepository
    ) -> SettingsView {

        let interactor = SettingsInteractor(
            userDetailsRepo: userDetailsRepo,
            subjectRepo: subjectRepo
        )

        let presenter = SettingsPresenter(interactor: interactor)

        return SettingsView(presenter: presenter)
    }
}
