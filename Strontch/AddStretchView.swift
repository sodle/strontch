//
//  AddStretchView.swift
//  Strontch
//
//  Created by Scott Odle on 1/18/25.
//

import SwiftUI

struct AddStretchView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = ""
    
    @State var reps: Int = 10
    @State var sets: Int = 1
    
    @State var isTimed: Bool = false
    @State var repTime: Int = 5
    
    var pluralizedReps: String {
        reps == 1 ? "1 rep" : "\(reps) reps"
    }
    var pluralizedSets: String {
        sets == 1 ? "1 set" : "\(sets) sets"
    }
    var pluralizedSeconds: String {
        repTime == 1 ? "1 second" : "\(repTime) seconds"
    }
    
    var body: some View {
        Form {
            TextField("Stretch Name", text: $name)
            
            Section("Counting") {
                Stepper(value: $reps, in: 1...Int.max) {
                    Text(pluralizedReps)
                }
                Stepper(value: $sets) {
                    Text(pluralizedSets)
                }
            }
            
            Section("Timing") {
                Toggle("Time per rep", isOn: $isTimed)
                
                if isTimed {
                    Stepper(value: $repTime, in: 1...60) {
                        Text(pluralizedSeconds)
                    }
                }
            }
            
            Button(action: {
                let stretch = Stretch(name: name, sets: sets, reps: reps)
                
                if isTimed {
                    stretch.holdTime = repTime
                }

                modelContext.insert(stretch)
                
                dismiss()
            }) {
                Text("Save")
            }.disabled(name.isEmpty)
        }.navigationTitle("New Stretch")
    }
}

#Preview {
    AddStretchView()
}
