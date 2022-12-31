//
//  ContentView.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI
import ComposableArchitecture

enum NavigationTabItems {
    case today, meditate
}

class NavigationViewModel: ObservableObject {
    @Published var selectedTab: NavigationTabItems = .meditate
    @Published var selectedMeditation: MeditationViewModel? = nil
    @Published var meditationPath: [Meditation] = []
    
    func navigate(to meditation: Meditation) {
        meditationPath = []
        meditationPath.append(meditation)
    }
    
    func clearNavigation() {
        meditationPath = []
    }
    
    func finishMeditation(for meditation: Meditation) {
        meditationPath = [meditation]
    }
}

struct ContentView: View {
    @ObservedObject var navVM = NavigationViewModel()
    
    let store = Store(
        initialState: Meditate.State(meditations: []),
        reducer: Meditate()
    )
    
    var body: some View {
        TabView(selection: self.$navVM.selectedTab) {
            Today()
                .tabItem {
                    Label("Today", systemImage: "sun.haze.fill")
                }
                .tag(NavigationTabItems.today)
            
            MeditateView(store: store)
                .tabItem {
                    Label("Meditate", systemImage: "figure.mind.and.body")
                }
                .tag(NavigationTabItems.meditate)
        }
        .environmentObject(navVM)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

