//
//  StretchProgressView.swift
//  Strontch
//
//  Created by Scott Odle on 1/19/25.
//

import SwiftUI

struct StretchProgressView: View {
    var stretch: Stretch
    
    @State private var setsCompleted = 0
    @State private var repsCompleted = 0
    
    @State private var timerStarted: Date?
    @State private var timerDuration: TimeInterval = 0
    
    fileprivate func repStartHaptic() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    fileprivate func repCompleteHaptic() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    fileprivate func setCompleteHaptic() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
    
    fileprivate func stretchCompleteHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    fileprivate func countRep() {
        repsCompleted += 1
        if repsCompleted >= stretch.reps {
            repsCompleted = 0
            setsCompleted += 1
            
            if setsCompleted >= stretch.sets {
                stretchCompleteHaptic()
                stretch.markCompleted()
            } else {
                setCompleteHaptic()
            }
        } else {
            repCompleteHaptic()
        }
    }
    
    var body: some View {
        VStack {
            ProgressView(
                value: Float(setsCompleted),
                total: Float(stretch.sets)
            ) {
                Text("\(setsCompleted) of \(stretch.pluralizedSets)")
            }.padding()
            
            ProgressView(
                value: Float(repsCompleted),
                total: Float(stretch.reps)
            ) {
                Text("\(repsCompleted) of \(stretch.pluralizedReps)")
            }.padding()
            
            if let holdTime = stretch.holdTime {
                ProgressView(
                    value: Float(timerDuration),
                    total: Float(holdTime)
                ) {
                    Text("Hold: \(Int(timerDuration)) of \(holdTime) seconds")
                }.padding()
            }
            
            Button(stretch.holdTime != nil ? "Start Timer" : "Count Rep") {
                if let holdTime = stretch.holdTime {
                    timerStarted = Date()
                    repStartHaptic()
                    Timer.scheduledTimer(
                        withTimeInterval: 0.1,
                        repeats: true) { timer in
                            timerDuration = Date().timeIntervalSince(timerStarted!)
                            if timerDuration >= Double(holdTime) {
                                timer.invalidate()
                                
                                countRep()
                                
                                timerStarted = nil
                                timerDuration = 0
                            }
                        }
                } else {
                    countRep()
                }
            }.disabled(repsCompleted >= stretch.reps || setsCompleted >= stretch.sets || timerStarted != nil)
            
            if setsCompleted >= stretch.sets {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .navigationTitle(stretch.name)
    }
}

#Preview("Untimed") {
    StretchProgressView(stretch: Stretch(name: "Reverse Clamshell", sets: 2, reps: 10))
}

#Preview("Timed") {
    StretchProgressView(stretch: Stretch(name: "Seated Hamstring Stretch", sets: 6, reps: 10, holdTime: 10))
}
