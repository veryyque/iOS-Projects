//
//  SoundCategory.swift
//  Relaxator
//
//  Created by Вероника Москалюк on 13.02.2026.
//

import SwiftUI

enum SoundCategory: String, CaseIterable, Identifiable {
    case rain = "Дождь"
    case fire = "Костер"
    case crickets = "Сверчки"
    case whiteNoise = "Белый шум"
    case ocean = "Океан"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .rain: return "cloud.rain.fill"
        case .fire: return "flame.fill"
        case .crickets: return "leaf.fill"
        case .whiteNoise: return "waveform"
        case .ocean: return "water.waves"
        }
    }
    
    var color: Color {
        switch self {
        case .rain: return Color(red: 0.0, green: 0.5, blue: 1.0)
        case .fire: return Color(red: 1.0, green: 0.5, blue: 0.0)
        case .crickets: return Color(red: 0.2, green: 0.8, blue: 0.2)
        case .whiteNoise: return Color(red: 0.5, green: 0.5, blue: 0.5)
        case .ocean: return Color(red: 0.0, green: 0.8, blue: 0.8)
        }
    }
    
    var fileName: String {
        switch self {
        case .rain: return "rain"
        case .fire: return "fire"
        case .crickets: return "crickets"
        case .whiteNoise: return "white_noise"
        case .ocean: return "ocean"
        }
    }
    
    var description: String {
        switch self {
        case .rain: return "Спокойный дождь для уюта"
        case .fire: return "Теплый треск костра"
        case .crickets: return "Летняя ночь в лесу"
        case .whiteNoise: return "Нейтральный фоновый шум"
        case .ocean: return "Шум прибоя и волн"
        }
    }
}
