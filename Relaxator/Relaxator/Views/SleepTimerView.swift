//
//  SleepTimerView.swift
//  Relaxator
//
//  Created by Вероника Москалюк on 13.02.2026.
//

import SwiftUI

struct SleepTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AudioManager.self) private var audioManager
    @State private var selectedMinutes: Int = 30
    @State private var isTimerActive = false
    
    let timerOptions = [15, 30, 45, 60, 90, 120]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.95)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Иконка
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.yellow)
                        .padding(.top, 40)
                    
                    Text("Таймер сна")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Автоматически выключит звук через выбранное время")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        Text("Выберите время")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(timerOptions, id: \.self) { minutes in
                                    TimeChip(
                                        minutes: minutes,
                                        isSelected: selectedMinutes == minutes
                                    )
                                    .onTapGesture {
                                        withAnimation {
                                            selectedMinutes = minutes
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                    
                    // Кнопка активации
                    Button {
                        audioManager.startSleepTimer(minutes: selectedMinutes)
                        isTimerActive = true
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "timer")
                            Text("Запустить таймер")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct TimeChip: View {
    let minutes: Int
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text("\(minutes)")
                .font(.title2)
                .fontWeight(.bold)
            Text("мин")
                .font(.caption)
        }
        .foregroundColor(isSelected ? .white : .white.opacity(0.7))
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? Color.blue : Color.gray.opacity(0.3))
        )
    }
}
