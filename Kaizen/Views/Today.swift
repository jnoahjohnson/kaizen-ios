//
//  Today.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI

class TodayViewModel: ObservableObject {
    @Published var meditations: [Meditation] = []
    @Published var favoriteMeditations: [Meditation] = []
}

struct Today: View {
    @ObservedObject var viewModel = TodayViewModel()
    @EnvironmentObject var navVM: NavigationViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Coming Soon...")
                
//                if let firstMeditation = viewModel.meditations.first {
//                    Button {
//                        self.navVM.selectedMeditation = MeditationViewModel(meditation: firstMeditation, onClose: {
//                            self.navVM.selectedMeditation = nil
//                        })
//                    } label: {
//                        MeditateCard(meditation: firstMeditation)
//                    }
//                }
                Spacer()
            }
            .padding()
            .navigationTitle("Today")
        }
    }
}

struct Today_Previews: PreviewProvider {
    static var previews: some View {
        Today()
    }
}
