//
//  ScribeApp.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

@main
struct ScribeApp: App {

    @State private var router = AppRouter()
    
    private let repository = StubNotesRepository()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {

                HomePageAsm.build(
                    appRouter: router,
                    notesRepo: repository
                )
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {

                    case .createNote:
                        CreateNoteAsm.build(
                            appRouter: router,
                            notesRepository: repository
                        )
                    }
                }
            }
        }
    }
}
