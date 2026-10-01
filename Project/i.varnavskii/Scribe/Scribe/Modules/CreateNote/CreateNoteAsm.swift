//
//  CreateNoteAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class CreateNoteAsm {
    
    static func build(
        appRouter: AppRouter,
        notesRepository: NotesRepository
    ) -> CreateNoteView {
        
        let interactor = CreateNoteInteractor(repo: notesRepository)
        
        let router = CreateNoteRouter(appRouter: appRouter)
        
        let presenter = CreateNotePresenter(
            interactor: interactor,
            router: router
        )
        
        return CreateNoteView(presenter: presenter)
    }
}
