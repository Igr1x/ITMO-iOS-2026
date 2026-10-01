//
//  RootView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

struct RootView: View {
    
    private let notesRepo: NotesRepository
    private let subjRepo: SubjectRepository
    private let userDetailsRepo: UserDetailsRepository
    
    @State private var homeRouter = AppRouter()
    @State private var notesRouter = AppRouter()
    
    init(
        notesRepo: NotesRepository,
        subjRepo: SubjectRepository,
        userDetailsRepo: UserDetailsRepository
    ) {
        self.notesRepo = notesRepo
        self.subjRepo = subjRepo
        self.userDetailsRepo = userDetailsRepo
    }
    
    var body: some View {
        TabView {
            NavigationStack(path: $homeRouter.path) {
                HomePageAsm.build(
                    appRouter: homeRouter,
                    notesRepo: notesRepo,
                    userDetailsRepo: userDetailsRepo,
                    subjectRepo: subjRepo
                )
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route, router: homeRouter)
                }
            }
            .tabItem {
                Label("Главная", systemImage: "house")
            }
            
            NavigationStack(path: $notesRouter.path) {
                NotesAsm.build(
                    notesRepo: notesRepo,
                    subjectRepo: subjRepo
                ) {
                    notesRouter.navigate(to: .createNote)
                }
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route, router: notesRouter)
                }
            }
            .tabItem {
                Label("Конспекты", systemImage: "book")
            }
            
            NavigationStack {
                ScheduleView()
            }
            .tabItem {
                Label("Расписание", systemImage: "calendar")
            }
            
            NavigationStack {
                SettingsAsm.build(
                    userDetailsRepo: userDetailsRepo,
                    subjectRepo: subjRepo
                )
            }
            .tabItem {
                Label("Настройки", systemImage: "gearshape")
            }
        }
    }
    
    @ViewBuilder
    private func destination(
        for route: AppRoute,
        router: AppRouter
    ) -> some View {
        switch route {
        case .createNote:
            CreateNoteAsm.build(
                appRouter: router,
                notesRepository: notesRepo,
                subjectRepository: subjRepo
            )
        case .createSubject:
            CreateSubjectAsm.build(
                appRouter: router,
                subjectRepository: subjRepo
            )
        }
    }
}
