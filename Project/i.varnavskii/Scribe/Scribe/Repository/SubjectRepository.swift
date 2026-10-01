//
//  SubjectRepository.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

protocol SubjectRepository {
    func save(_ subject: Subject)
    
    func getAll() -> [Subject]
    
    func delete(_ title: String)
}

final class StubSubjectRepository: SubjectRepository {
    
    private var subjects: [String: Subject] = [:]
    
    func save(_ subject: Subject) {
        subjects[subject.title] = subject
    }
    
    func getAll() -> [Subject] {
        return subjects.map { $0.value }
    }
    
    func delete(_ title: String) {
        subjects.removeValue(forKey: title)
    }
}
