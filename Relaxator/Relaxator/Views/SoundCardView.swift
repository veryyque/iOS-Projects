//
//  SoundCardView.swift
//  Relaxator
//
//  Created by Вероника Москалюк on 13.02.2026.
//

import SwiftUI

struct SoundCardView: View {
    let category: SoundCategory
    let isSelected: Bool
    let isPlaying: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.iconName)
                    .font(.system(size: 36))
                    .foregroundColor(category.color)
                    .symbolEffect(.bounce, value: isPlaying)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                Spacer()
                
                if isPlaying {
                    WaveformView(color: category.color)
                        .frame(width: 40, height: 24)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(category.description)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(category.color, lineWidth: 2)
                        .shadow(color: category.color.opacity(0.5), radius: 8)
                }
            }
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct WaveformView: View {
    let color: Color
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<4) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 3, height: animate ? 16 : 8 + CGFloat(index * 4))
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
#Preview {
    ContentView()
        .environment(AudioManager())
}
