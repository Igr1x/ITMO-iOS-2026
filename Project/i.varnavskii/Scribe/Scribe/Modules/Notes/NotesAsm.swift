//
//  NotesAsm.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

final class NotesAsm {
    
    static func build(
        notesRepo: NotesRepository,
        subjectRepo: SubjectRepository,
        notesSearchWorker: NotesSearchWorker,
        onCreateNote: @escaping () -> Void
    ) -> NotesView {
        
        let interactor = NotesInteractor(
            notesRepo: notesRepo,
            subjectRepo: subjectRepo
        )
        
        let presenter = NotesPresenter(
            interactor: interactor,
            notesSearchWorker: notesSearchWorker
        )
        
        return NotesView(
            presenter: presenter,
            onCreateNote: onCreateNote
        )
    }
}
