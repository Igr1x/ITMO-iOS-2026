//
//  CreateNoteAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class CreateNoteAsm {
    
    static func build(
        appRouter: AppRouter,
        notesRepository: NotesRepository,
        subjectRepository: SubjectRepository
    ) -> CreateNoteView {
        
        let interactor = CreateNoteInteractor(
            repo: notesRepository,
            subjectRepo: subjectRepository
        )
        
        let router = CreateNoteRouter(appRouter: appRouter)
        
        let presenter = CreateNotePresenter(
            interactor: interactor,
            router: router
        )
        
        return CreateNoteView(presenter: presenter)
    }
}
