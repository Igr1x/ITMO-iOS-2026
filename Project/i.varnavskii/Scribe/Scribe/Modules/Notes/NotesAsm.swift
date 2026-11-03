//
//  NotesAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class NotesAsm {

    static func build(
        appRouter: AppRouter,
        notesRepo: NotesRepository,
        subjectRepo: SubjectRepository,
        notesSearchWorker: NotesSearchWorker,
        contentRepository: any NoteContentRepository
    ) -> NotesView {

        let interactor = NotesInteractor(
            notesRepo: notesRepo,
            subjectRepo: subjectRepo,
            contentRepository: contentRepository
        )

        let presenter = NotesPresenter(
            interactor: interactor,
            notesSearchWorker: notesSearchWorker,
            router: NotesRouter(appRouter: appRouter)
        )

        return NotesView(presenter: presenter)
    }
}
