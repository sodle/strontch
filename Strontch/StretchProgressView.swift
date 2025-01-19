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
                    Timer.scheduledTimer(
                        withTimeInterval: 0.1,
                        repeats: true) { timer in
                            timerDuration = Date().timeIntervalSince(timerStarted!)
                            if timerDuration >= Double(holdTime) {
                                timer.invalidate()
                                repsCompleted += 1
                                if repsCompleted >= stretch.reps {
                                    repsCompleted = 0
                                    setsCompleted += 1
                                    
                                    if setsCompleted >= stretch.sets {
                                        stretch.markCompleted()
                                    }
                                }
                                
                                timerStarted = nil
                                timerDuration = 0
                            }
                        }
                } else {
                    repsCompleted += 1
                    if repsCompleted >= stretch.reps {
                        repsCompleted = 0
                        setsCompleted += 1
                        
                        if setsCompleted >= stretch.sets {
                            stretch.markCompleted()
                        }
                    }
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
