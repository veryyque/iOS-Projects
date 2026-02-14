//
//  SoundSettings.swift
//  Relaxator
//
//  Created by Вероника Москалюк on 13.02.2026.
//

import Foundation

struct SoundSettings: Codable {
    var lastPlayedSound: String = "rain"
    var volume: Double = 0.5
    var isSleepTimerEnabled: Bool = false
    var sleepTimerDuration: TimeInterval = 1800
    
    static let defaults = SoundSettings()
}

extension SoundSettings {
    static func save(_ settings: SoundSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "SoundSettings")
        }
    }
    
    static func load() -> SoundSettings {
        guard let data = UserDefaults.standard.data(forKey: "SoundSettings"),
              let settings = try? JSONDecoder().decode(SoundSettings.self, from: data) else {
            return SoundSettings.defaults
        }
        return settings
    }
}
