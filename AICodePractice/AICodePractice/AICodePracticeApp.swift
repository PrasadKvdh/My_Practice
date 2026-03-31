//
//  AICodePracticeApp.swift
//  AICodePractice
//
//  Created by Prasad Kukkala on 12/21/25.
//

import SwiftUI
import SwiftData

@main
struct AICodePracticeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Person.self, Message.self])
    }
}
