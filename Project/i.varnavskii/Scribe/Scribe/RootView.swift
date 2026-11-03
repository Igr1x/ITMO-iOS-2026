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
    private let noteContentRepository: any NoteContentRepository

    @State private var homeRouter = AppRouter()
    @State private var notesRouter = AppRouter()

    init(
        notesRepo: NotesRepository,
        subjRepo: SubjectRepository,
        userDetailsRepo: UserDetailsRepository,
        notesSearchWorker: NotesSearchWorker,
        calendarRepository: CalendarEventRepository,
        calendarImportService: any CalendarImportService = GoogleCalendarImportService(),
        noteContentRepository: any NoteContentRepository
    ) {
        self.notesRepo = notesRepo
        self.subjRepo = subjRepo
        self.userDetailsRepo = userDetailsRepo
        self.notesSearchWorker = notesSearchWorker
        self.calendarRepository = calendarRepository
        self.calendarImportService = calendarImportService
        self.noteContentRepository = noteContentRepository
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
                    appRouter: notesRouter,
                    notesRepo: notesRepo,
                    subjectRepo: subjRepo,
                    notesSearchWorker: notesSearchWorker,
                    contentRepository: noteContentRepository
                )
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
        case .editNote(let note):
            EditNoteAsm.build(note: note, appRouter: router, contentRepository: noteContentRepository)
        }
    }
}
