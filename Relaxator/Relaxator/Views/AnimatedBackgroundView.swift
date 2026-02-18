//
//  AnimatedBackgroundView.swift
//  Relaxator
//
//  Created by Вероника Москалюк on 18.02.2026.
//

import Foundation
import SwiftUI
import AVKit

struct AnimatedBackgroundView: View {
    let category: SoundCategory
    
    var body: some View {
        switch category {
        case .rain:
            RainBackgroundView()
        case .fire:
            FireBackgroundView()
        case .ocean:
            OceanBackgroundView()
        case .crickets:
            ForestBackgroundView()
        case .whiteNoise:
            AbstractBackgroundView()
        }
    }
}

struct RainBackgroundView: View {
    var body: some View {
        VideoPlayerView(videoName: "rain_video", videoType: "mp4")
    }
}

struct FireBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [.orange, .red, .black],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct OceanBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [.blue, .cyan, .teal],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct ForestBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [.green, .darkGreen, .black],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct AbstractBackgroundView: View {
    @State private var animate = false
    
    var body: some View {
        Circle()
            .fill(.gray.opacity(0.3))
            .scaleEffect(animate ? 1.5 : 1.0)
            .animation(
                .easeInOut(duration: 2).repeatForever(),
                value: animate
            )
            .onAppear { animate = true }
    }
}

// Для видео
struct VideoPlayerView: View {
    let videoName: String
    let videoType: String
    
    var body: some View {
        if let url = Bundle.main.url(forResource: videoName, withExtension: videoType) {
            VideoPlayer(player: AVPlayer(url: url))
                .onAppear {
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: nil,
                        queue: .main
                    ) { _ in
                    }
                }
        } else {
            Color.gray.opacity(0.3) 
        }
    }
}

extension Color {
    static let darkGreen = Color(red: 0.0, green: 0.4, blue: 0.0)
}
