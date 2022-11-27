//
//  Meditate.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI
import ComposableArchitecture


struct MeditateView: View {
    let store: StoreOf<Meditate>
    @EnvironmentObject private var navVM: NavigationViewModel
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: $navVM.meditationPath) {
                ScrollView {
                    VStack {
                        ForEach(viewStore.meditations) { meditation in
                            Button {
                                self.navVM.selectedMeditation = MeditationViewModel(meditation: meditation, onClose: {
                                    self.navVM.selectedMeditation = nil
                                } )
                            } label: {
                                MeditateCard(meditation: meditation)
                            }
                        }
                        
                    }
                    .padding()
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.updateShowAddMeditation(true))
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
                .sheet(isPresented: viewStore.binding(
                    get: \.showAddMeditation,
                    send: Meditate.Action.updateShowAddMeditation)
                ) {
                    AddMeditation(store: store)
                }
                .navigationDestination(for: Meditation.self) { meditation in
                    MeditationPage(meditation: meditation, onClose: {
                        self.navVM.clearNavigation()
                    })
                }
                
                .navigationTitle("Meditate")
                .onAppear { viewStore.send(.loadMeditations) }
            }
        }
    }
    
}

struct MeditateView_Previews: PreviewProvider {
    static var previews: some View {
        MeditateView(store: Store(
            initialState: Meditate.State(meditations: [.defaultInstance]),
            reducer: Meditate()
        ))
        .environmentObject(NavigationViewModel())
    }
}
