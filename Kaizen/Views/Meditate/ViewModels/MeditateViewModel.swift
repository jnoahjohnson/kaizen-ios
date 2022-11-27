//
//  MeditateViewModel.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import Foundation



class MeditateViewModel: ObservableObject {
    static let shared = MeditateViewModel()
    
    let store = MeditationStore()

    @Published var meditations: [Meditation] = []


}
