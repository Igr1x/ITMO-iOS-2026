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
    private let notesSearchWorker: NotesSearchWorker
    private let calendarRepository: CalendarEventRepository
    private let calendarImportService: any CalendarImportService
    
    @State private var homeRouter = AppRouter()
    @State private var notesRouter = AppRouter()
    
    init(
        notesRepo: NotesRepository,
        subjRepo: SubjectRepository,
        userDetailsRepo: UserDetailsRepository,
        notesSearchWorker: NotesSearchWorker,
        calendarRepository: CalendarEventRepository,
        calendarImportService: any CalendarImportService = GoogleCalendarImportService()
    ) {
        self.notesRepo = notesRepo
        self.subjRepo = subjRepo
        self.userDetailsRepo = userDetailsRepo
        self.notesSearchWorker = notesSearchWorker
        self.calendarRepository = calendarRepository
        self.calendarImportService = calendarImportService
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
                    subjectRepo: subjRepo,
                    notesSearchWorker: notesSearchWorker
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
                ScheduleAsm.build(repository: calendarRepository, importService: calendarImportService)
            }
            .tabItem {
                Label("Календарь", systemImage: "calendar")
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
