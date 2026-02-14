//
//  RelaxatorApp.swift
//  Relaxator
//
//  Created by Вероника Москалюк on 13.02.2026.

import SwiftUI

@main
struct RelaxatorApp: App {
    @State private var audioManager = AudioManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(audioManager)
                .preferredColorScheme(.dark)
        }
    }
}
