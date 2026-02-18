import AVFoundation
import UIKit
import SwiftUI

@available(iOS 26.0, *)
class AudioService {
    static let shared = AudioService()
    private init() {}
    
    func requestPermissions() async throws -> Bool {
        let permission = await AVAudioApplication.requestRecordPermission()
        
        if permission == true {
            return true
        } else {
            throw AudioError.permissionDenied
        }
    }
    
    @MainActor
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Нет доступа к аудио",
            message: "Разрешите доступ в настройках",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.keyWindow else { return }
        
        window.rootViewController?.present(alert, animated: true)
    }
    
    func validateSoundFiles() -> [SoundFileStatus] {
        SoundCategory.allCases.compactMap { category in
            let url = Bundle.main.url(forResource: category.fileName, withExtension: "mp3")
            return SoundFileStatus(category: category, exists: url != nil)
        }
        .filter { !$0.exists }
    }
}

enum AudioError: LocalizedError {
    case permissionDenied
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Нет доступа к микрофону"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}

struct SoundFileStatus: Identifiable {
    let id = UUID()
    let category: SoundCategory
    let exists: Bool
}

