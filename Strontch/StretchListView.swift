//
//  StretchListView.swift
//  Strontch
//
//  Created by Scott Odle on 1/19/25.
//

import SwiftUI

struct StretchListView: View {
    var stretch: Stretch
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(stretch.name).font(.headline)
            HStack{
                Text("\(stretch.pluralizedSets) of \(stretch.pluralizedReps)")
                if let holdTime = stretch.holdTime {
                    Text("•")
                    Text("\(holdTime)sec hold")
                }
            }
        }
    }
}
#Preview("Untimed") {
    StretchListView(stretch: Stretch(name: "Clamshells", sets: 2, reps: 10))
}

#Preview("Timed") {
    StretchListView(stretch: Stretch(name: "Seated Hamstring Stretch", sets: 1, reps: 3, holdTime: 10))
}
