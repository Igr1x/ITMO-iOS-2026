//
//  Router.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import Observation

@Observable
final class AppRouter {

    var path: [AppRoute] = []

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    func back() {
        guard !path.isEmpty else {
            return
        }

        path.removeLast()
    }

    func toRoot() {
        path.removeAll()
    }
}
