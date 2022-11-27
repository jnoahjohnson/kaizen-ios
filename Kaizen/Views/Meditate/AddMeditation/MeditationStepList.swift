//
//  MeditationStepList.swift
//  Kaizen
//
//  Created by Noah Johnson on 11/26/22.
//

import SwiftUI

struct MeditationStepList: View {
    @Binding var steps: [Step]
    @State var newStep: String = ""
    
    func move(from source: IndexSet, to destination: Int) {
        steps.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        steps.remove(atOffsets: offsets)
    }
    
    var body: some View {
        List {
            ForEach($steps) { $step in
                TextField("Title", text: $step.title)
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
            
            HStack {
                TextField("New Step", text: $newStep)
                Spacer()
                Button("Add") {
                    steps.append(Step(title: newStep))
                    newStep = ""
                }
            }
            
        }
        .toolbar {
            EditButton()
        }
    }
}

struct MeditationStepList_Previews: PreviewProvider {
    static var previews: some View {
        MeditationStepList(steps: .constant([Step(title: "Sight")]))
    }
}
