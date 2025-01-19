//
//  ContentView.swift
//  Strontch
//
//  Created by Scott Odle on 1/14/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Stretch.dateCreated) private var stretches: [Stretch]
    
    @State var sidebarVisibility = NavigationSplitViewVisibility.all

    var body: some View {
        NavigationSplitView(columnVisibility: $sidebarVisibility) {
            List {
                ForEach(stretches) { stretch in
                    NavigationLink {
                        StretchProgressView(stretch: stretch)
                    } label: {
                        StretchListView(stretch: stretch)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink {
                        AddStretchView()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }

                }
            }.toolbar(removing: .sidebarToggle)
            .navigationTitle("Strontch")
        } detail: {
            Text("Pick a stretch to get started")
        }.navigationSplitViewStyle(.balanced)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(stretches[index])
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Stretch.self, configurations: config)
    
    container.mainContext.insert(
        Stretch(name: "Clamshell", sets: 2, reps: 10)
    )
    container.mainContext.insert(
        Stretch(name: "Seated Hamstring Stretch", sets: 6, reps: 10, holdTime: 30)
    )
    
    return ContentView()
        .modelContainer(container)
}
