//
//  EditNoteAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 03.11.2026.
//

enum EditNoteAsm {
    static func build(
        note: Note,
        appRouter: AppRouter,
        contentRepository: any NoteContentRepository
    ) -> EditNoteView {
        let interactor = EditNoteInteractor(noteID: note.id, repository: contentRepository)
        let router = EditNoteRouter(appRouter: appRouter)
        let presenter = EditNotePresenter(note: note, interactor: interactor, router: router)
        return EditNoteView(presenter: presenter)
    }
}
