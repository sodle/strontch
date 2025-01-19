//
//  Stretch.swift
//  Strontch
//
//  Created by Scott Odle on 1/14/25.
//

import Foundation
import SwiftData

@Model
final class Stretch {
    var name: String
    var sets: Int
    var reps: Int
    var holdTime: Int?
    var dateCreated: Date
    
    var lastCompleted: Date?
    
    init(name: String, sets: Int, reps: Int, holdTime: Int? = nil) {
        self.name = name
        self.sets = sets
        self.reps = reps
        self.holdTime = holdTime
        
        self.dateCreated = Date()
    }
    
    func markCompleted() {
        lastCompleted = Date()
        try! modelContext?.save()
    }
    
    func clearCompletion() {
        lastCompleted = nil
        try! modelContext?.save()
    }
    
    @Transient var completedToday: Bool {
        guard let lastCompleted = lastCompleted else { return false }
        return Calendar.current.isDateInToday(lastCompleted)
    }
    
    @Transient var pluralizedReps: String {
        return reps == 1 ? "1 rep" : "\(reps) reps"
    }
    
    @Transient var pluralizedSets: String {
        return sets == 1 ? "1 set" : "\(sets) sets"
    }
}
