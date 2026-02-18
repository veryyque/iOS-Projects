//
//  SoundDetailView.swift
//  Relaxator
//
//  Created by Вероника Москалюк on 18.02.2026.
//

import SwiftUI
import AVFoundation

struct SoundDetailView: View {
    let category: SoundCategory
    @Environment(AudioManager.self) private var audioManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingVolumeSlider = true
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
           
            AnimatedBackgroundView(category: category)
                .ignoresSafeArea()
            
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                HStack {
                    Button {
                        dismiss() 
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: category.iconName)
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(color: category.color, radius: 20)
                    
                    Text(category.rawValue)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(category.description)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    // Ползунок громкости
                    if showingVolumeSlider {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "speaker.fill")
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Slider(
                                    value: Binding(
                                        get: { audioManager.volume },
                                        set: { audioManager.setVolume($0) }
                                    ),
                                    in: 0...1,
                                    step: 0.01
                                )
                                .tint(.white)
                                
                                Image(systemName: "speaker.wave.3.fill")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Text("\(Int(audioManager.volume * 100))%")
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    HStack(spacing: 30) {
                        // Stop
                        Button {
                            withAnimation {
                                audioManager.stop()
                            }
                        } label: {
                            Image(systemName: "stop.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        
                        Button {
                            withAnimation {
                                if audioManager.isPlaying && audioManager.currentSound == category {
                                    audioManager.togglePlayPause()
                                } else {
                                    audioManager.playSound(category)
                                }
                            }
                        } label: {
                            Image(systemName: audioManager.isPlaying && audioManager.currentSound == category ? "pause.fill" : "play.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(audioManager.isPlaying && audioManager.currentSound == category ? Color.blue : Color.green)
                                .clipShape(Circle())
                        }
                        
                        Button {
                            withAnimation {
                                showingVolumeSlider.toggle()
                            }
                        } label: {
                            Image(systemName: showingVolumeSlider ? "chevron.down" : "chevron.up")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(24)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .onAppear {
            if audioManager.currentSound != category {
                audioManager.playSound(category)
            }
        }
        .onDisappear {
            // По желанию: останавливать звук при уходе
            // audioManager.stop()
        }
    }
}
