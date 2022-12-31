//
//  MeditationViewModel.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import Foundation
import AVFoundation
import SwiftUI
import ComposableArchitecture

class MeditationViewModel: ObservableObject, Identifiable {
    @Published var meditation: Meditation
    let store: ViewStoreOf<Meditate>
    @Published var timeLeft: String = "1:00"
    @Published var currentTitle: String = ""
    @Published var progress: Float = 0.0
    
    @Published var isPlaying = false
    @Published var isFinished = true
    @Published var hasBegun = false
    
    @Published var isFirstStep = true
    @Published var isLastStep = false
    
    let totalTime = 60
    
    let steps: [String]
    
    let onClose: () -> Void
    
    var currentStep: Int = 0 {
        willSet {
            currentTitle = steps[newValue]
            
            if (newValue > 0) {
                isFirstStep = false
            } else {
                isFirstStep = true
            }
            
            if (newValue == steps.count - 1) {
                isLastStep = true
            } else {
                isLastStep = false
            }
        }
    }
    
    var currentDuration: Int {
        willSet {
            self.timeLeft = timeLeftString(newValue)
            self.progress = 1.0 - Float(Float(self.duration - newValue)/Float(self.duration))
            print("progess", self.progress)
        }
    }
    
    var duration: Int
    var timer = Timer()
    var id: UUID
    
    init(meditation: Meditation, store: ViewStoreOf<Meditate>, onClose: @escaping () -> Void) {
        self.meditation = meditation
        self.id = meditation.id
        self.duration = meditation.stepDuration
        self.currentDuration = meditation.stepDuration
        self.steps = meditation.steps
        self.currentTitle = self.steps[0]
        self.onClose = onClose
        self.store = store
    }
    
    
    func incrementProgress() {
        let randomValue = Float([0.012, 0.022, 0.034, 0.016, 0.11].randomElement()!)
        self.progress += randomValue
    }
    
    func startTimer() {
        self.isPlaying = true
        self.currentDuration -= 1
        self.hasBegun = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentDuration -= 1
            if self.currentDuration <= 0 {
                self.nextStep()
            }
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        isPlaying = false
        progress = 0
        currentDuration = 0
    }
    
    func pauseTimer() {
        // Pause
        timer.invalidate()
        isPlaying = false
    }
    
    func timeLeftString(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        
        return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
    }
    
    func nextStep() {
        if (currentTitle == steps.last) {
            finishMeditation()
        } else {
            currentStep += 1
            currentDuration = duration
            playStepSound()
        }
        
        
    }
    
    func prevStep() {
        if (currentTitle == steps.first) {
            finishMeditation()
        } else {
            currentStep -= 1
            currentDuration = duration
            playStepSound()
        }
    }
    
    func finishMeditation() {
        stopTimer()
        isFinished = true
        
        self.store.send(.finishMeditation(self.meditation.id))
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        onClose()
    }
    
    func cancel() {
        stopTimer()
        UIApplication.shared.isIdleTimerDisabled = false
        onClose()
    }
    
    func playStepSound() {
        let systemSoundID: SystemSoundID = 1104
        let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
        
        AudioServicesPlaySystemSound(systemSoundID)
        AudioServicesPlaySystemSound(vibrate)
    }
}
