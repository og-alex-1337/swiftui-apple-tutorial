//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by aleksanderogurtsov on 01.10.2022.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewScrumView = false
    @State private var newScrumData = DailyScrum.Data()
    let saveAction: ()->Void
    
    var body: some View {
        List {
            ForEach($scrums, id: \.id) { $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
        }
        .navigationTitle("Daily Scrums")
        .toolbar {
            Button(action: {
                isPresentingNewScrumView = true
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NavigationView {
               DetailEditView(data: $newScrumData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction, content: {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                                newScrumData = DailyScrum.Data()
                            }
                        })
                        ToolbarItem(placement: .confirmationAction, content: {
                            Button("Add") {
                                let newScrum = DailyScrum(data: newScrumData)
                                scrums.append(newScrum)
                                isPresentingNewScrumView = false
                                newScrumData = DailyScrum.Data()
                            }
                        })
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
        }
    }
}
