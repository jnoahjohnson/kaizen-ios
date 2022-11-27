//
//  FinishMeditation.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/18/22.
//

import SwiftUI

struct FinishMeditation: View {
    var meditation: Meditation
    
    var body: some View {
        Text("You Finished!")
            .font(.largeTitle.bold())
    }
}

struct FinishMeditation_Previews: PreviewProvider {
    static var previews: some View {
        FinishMeditation(meditation: .defaultInstance)
    }
}
