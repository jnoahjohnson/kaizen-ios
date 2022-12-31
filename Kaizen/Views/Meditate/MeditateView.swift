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
                
                List {
                    ForEach(viewStore.meditations) { meditation in
                        Button {
                            self.navVM.selectedMeditation = MeditationViewModel(meditation: meditation, store: viewStore, onClose: {
                                self.navVM.selectedMeditation = nil
                            } )
                        } label: {
                            MeditateCard(meditation: meditation)
                        }
                    }
                    .onDelete { indexSet in viewStore.send(.deleteMeditation(indexSet)) }
                    .listRowSeparator(.hidden)
                    
                    
                }
                .listStyle(.plain)
                     
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.updateShowAddMeditation(true))
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                    
                    ToolbarItem(placement: .secondaryAction) {
                        EditButton()
                    }
                }
                
                .sheet(isPresented: viewStore.binding(
                    get: \.showAddMeditation,
                    send: Meditate.Action.updateShowAddMeditation)
                ) {
                    AddMeditation(store: store)
                }
                .sheet(item: $navVM.selectedMeditation, onDismiss: {
                    self.navVM.selectedMeditation = nil
                }) { item in
                    MeditationDetailPage(store: self.store, meditation: item.meditation, onMeditate: {
                        self.navVM.selectedTab = .meditate
                        self.navVM.navigate(to: navVM.selectedMeditation!.meditation)
                        self.navVM.selectedMeditation = nil
                    })
                }
                .navigationDestination(for: Meditation.self) { meditation in
                    MeditationPage(meditation: meditation, store: viewStore, onClose: {
                        self.navVM.clearNavigation()
                    })
                }
                
                .navigationTitle("Meditate")
                .task {
                    viewStore.send(.loadMeditations)
                }
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
