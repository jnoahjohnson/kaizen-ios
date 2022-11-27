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
    private var meditationStore = MeditationStore()
    
    
    func loadMeditations() {
        MeditationStore.load { result in
            switch result {
            case .failure(_):
                print("Could not load file")
            case.success(let meditations):
                if meditations.isEmpty {
                    print("Meditations are empty")
                    
                    MeditationStore.save(meditations: [.defaultInstance], completion: { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case.success(_):
                            print("Saved")
                        }
                    })
                    
                    self.meditations = [.defaultInstance]
                } else {
                    self.meditations = meditations
                }
            }
        }
    }
}

struct Today: View {
    @ObservedObject private var meditationVM = MeditateViewModel.shared
    @ObservedObject var viewModel = TodayViewModel()
    @EnvironmentObject var navVM: NavigationViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let firstMeditation = viewModel.meditations.first {
                    Button {
                        self.navVM.selectedMeditation = MeditationViewModel(meditation: firstMeditation, onClose: {
                            self.navVM.selectedMeditation = nil
                        })
                    } label: {
                        MeditateCard(meditation: firstMeditation)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Today")
        }
        .onAppear(perform: self.viewModel.loadMeditations)
    }
}

struct Today_Previews: PreviewProvider {
    static var previews: some View {
        Today()
    }
}
