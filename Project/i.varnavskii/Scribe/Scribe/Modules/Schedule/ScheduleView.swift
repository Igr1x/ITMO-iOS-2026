//
//  ScheduleView.swift
//  Scribe
//
//  Created by Варнавский Игорь Витальевич on 01.10.2026.
//

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        ContentUnavailableView(
            "Расписание",
            systemImage: "calendar"
        )
        .navigationTitle("Расписание")
    }
}
