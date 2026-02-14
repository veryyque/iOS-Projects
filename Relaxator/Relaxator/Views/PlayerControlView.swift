import SwiftUI

struct PlayerControlsView: View {
    @Environment(AudioManager.self) private var audioManager
    @State private var showingVolumeSlider = true
    
    var body: some View {
        // Добавляем @Bindable для доступа к $audioManager
        @Bindable var audioManager = audioManager
        
        VStack(spacing: 20) {
            if let currentSound = audioManager.currentSound {
                HStack {
                    Image(systemName: currentSound.iconName)
                        .font(.title2)
                        .foregroundColor(currentSound.color)
                    
                    Text(currentSound.rawValue)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            
            if showingVolumeSlider {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "speaker.fill")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Slider(
                            value: $audioManager.volume,
                            in: 0...1,
                            step: 0.01
                        )
                        .onChange(of: audioManager.volume) { oldValue, newValue in
                            audioManager.setVolume(newValue)
                        }
                        .tint(.white)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Text("\(Int(audioManager.volume * 100))%")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            HStack(spacing: 30) {
                Button(action: {
                    withAnimation {
                        audioManager.stop()
                    }
                }) {
                    Image(systemName: "stop.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    withAnimation {
                        audioManager.togglePlayPause()
                    }
                }) {
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(audioManager.isPlaying ? Color.blue : Color.green)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    withAnimation {
                        showingVolumeSlider.toggle()
                    }
                }) {
                    Image(systemName: showingVolumeSlider ? "chevron.down" : "chevron.up")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
    }
}

#Preview {
    let audioManager = AudioManager()
    return PlayerControlsView()
        .environment(audioManager)
        .preferredColorScheme(.dark)
}
