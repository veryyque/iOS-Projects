//
//  Constants.swift
//  Relaxator
//
//  Created by Вероника Москалюк on 13.02.2026.
//

import SwiftUI

enum Constants {
    // Размеры
    static let cornerRadius: CGFloat = 20
    static let smallCornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    
    // Анимации
    static let springAnimation = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let defaultAnimation = Animation.easeInOut(duration: 0.3)
    
    // SF Symbols
    enum Icons {
        static let play = "play.fill"
        static let pause = "pause.fill"
        static let stop = "stop.fill"
        static let volume = "speaker.wave.3.fill"
        static let volumeOff = "speaker.slash.fill"
        static let timer = "timer"
        static let settings = "gear"
        static let sleep = "moon.fill"
    }
    
    // UserDefaults keys
    enum UserDefaultsKeys {
        static let soundSettings = "SoundSettings"
        static let lastPlayedSound = "LastPlayedSound"
        static let volume = "Volume"
    }
}
