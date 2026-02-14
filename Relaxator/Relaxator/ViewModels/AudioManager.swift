import Foundation
import AVFoundation
import SwiftUI
import Observation

@available(iOS 26.0, *)
@Observable // Вместо ObservableObject
class AudioManager {
    // @Published больше не нужен с @Observable
    var isPlaying = false
    var volume: Double = 0.5 {
        didSet {
            setVolume(volume)
            saveSettings()
        }
    }
    var currentSound: SoundCategory?
    var timeRemaining: TimeInterval = 0
    var isSleepTimerActive = false
    
    private var audioPlayer: AVAudioPlayer?
    private var sleepTimer: Task<Void, Never>? // Используем Task вместо Timer
    
    init() {
        Task {
            await configureAudioSession()
            await loadSettings()
        }
    }
    
    // MARK: - Public Methods
    
    func playSound(_ category: SoundCategory) {
        stop()
        
        guard let url = Bundle.main.url(forResource: category.fileName, withExtension: "mp3") else {
            print("❌ Звук не найден: \(category.fileName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = Float(volume)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            currentSound = category
            isPlaying = true
            
            print("✅ Воспроизведение: \(category.rawValue)")
            saveSettings()
            
        } catch {
            print("❌ Ошибка воспроизведения: \(error.localizedDescription)")
        }
    }
    
    func togglePlayPause() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentSound = nil
        stopSleepTimer()
    }
    
    func setVolume(_ newVolume: Double) {
        let clamped = max(0, min(1, newVolume))
        if clamped != volume {
            volume = clamped
        }
        audioPlayer?.volume = Float(volume)
    }
    
    // MARK: - Sleep Timer с async/await
    
    func startSleepTimer(minutes: Int) {
        stopSleepTimer()

        let timeInterval = TimeInterval(minutes * 60)
        timeRemaining = timeInterval
        isSleepTimerActive = true

        sleepTimer = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled && self.timeRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                await MainActor.run {
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    }
                }
            }
            await MainActor.run {
                if !Task.isCancelled && self.timeRemaining <= 0 {
                    self.stop()
                }
                self.stopSleepTimer()
            }
        }
    }
    
    func stopSleepTimer() {
        sleepTimer?.cancel()
        sleepTimer = nil
        isSleepTimerActive = false
        timeRemaining = 0
    }
    
    // MARK: - Private Methods
    
    private func configureAudioSession() async {
        do {
            // Новый API для iOS 26
            let session = AVAudioSession.sharedInstance()
            try await session.setCategory(
                .playback,
                mode: .default,
                policy: .longFormAudio, // Новая политика
                options: [.mixWithOthers, .allowAirPlay, .duckOthers]
            )
            try await session.setActive(true)
            print("✅ Audio session configured")
        } catch {
            print("❌ Failed to configure audio session: \(error)")
        }
    }
    
    private func saveSettings() {
        var settings = SoundSettings.load()
        settings.lastPlayedSound = currentSound?.fileName ?? "rain"
        settings.volume = volume
        SoundSettings.save(settings)
    }
    
    private func loadSettings() async {
        let settings = await Task.detached {
            SoundSettings.load()
        }.value
        volume = settings.volume
    }
    
    // MARK: - Formatted Time
    
    var formattedTimeRemaining: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
