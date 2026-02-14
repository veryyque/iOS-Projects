import AVFoundation
import UIKit
import SwiftUI

@available(iOS 26.0, *)
class AudioService {
    static let shared = AudioService()
    private init() {}
    
    // Новейший API для iOS 26
    func requestPermissions() async throws -> Bool {
        // В iOS 26 используется асинхронный API
        let permission = await AVAudioApplication.requestRecordPermission()
        
        if permission == true {
            return true
        } else {
            throw AudioError.permissionDenied
        }
    }
    
    // Современный способ показа настроек
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
        
        // Новый способ получения rootViewController в iOS 26
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.keyWindow else { return }
        
        window.rootViewController?.present(alert, animated: true)
    }
    
    // Проверка звуковых файлов с использованием новой системы
    func validateSoundFiles() -> [SoundFileStatus] {
        SoundCategory.allCases.compactMap { category in
            let url = Bundle.main.url(forResource: category.fileName, withExtension: "mp3")
            return SoundFileStatus(category: category, exists: url != nil)
        }
        .filter { !$0.exists }
    }
}

// Современная обработка ошибок
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

// Структура для статуса файлов
struct SoundFileStatus: Identifiable {
    let id = UUID()
    let category: SoundCategory
    let exists: Bool
}

