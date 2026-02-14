import SwiftUI

struct ContentView: View {
    @Environment(AudioManager.self) private var audioManager
    
    @State private var selected: SoundCategory = .rain
    @State private var showTimer = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 249/255.0, green: 209/255.0, blue: 217/255.0),
                        Color(red: 2/255, green: 30/255, blue: 50/255),
                        Color(red: 249/255.0, green: 209/255.0, blue: 217/255.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Релаксатор")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                        
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 160), spacing: 16)
                        ], spacing: 20) {
                            ForEach(SoundCategory.allCases) { sound in
                                SoundCardView(
                                    category: sound,
                                    isSelected: selected == sound,
                                    isPlaying: audioManager.isPlaying && selected == sound
                                )
                                .onTapGesture {
                                    selected = sound
                                    audioManager.playSound(sound)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        if audioManager.isPlaying {
                            PlayerControlsView()
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showTimer.toggle()
                    } label: {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showTimer) {
                SleepTimerView()
                    .environment(audioManager)
            }
        }
        .onAppear {
            let settings = SoundSettings.load()
            if let found = SoundCategory.allCases.first(where: { $0.fileName == settings.lastPlayedSound }) {
                selected = found
            }
            audioManager.volume = settings.volume
        }
    }
}

#Preview {
    ContentView()
        .environment(AudioManager())
}
