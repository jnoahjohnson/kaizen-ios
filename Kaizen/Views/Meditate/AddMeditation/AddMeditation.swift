//
//  AddMeditation.swift
//  Kaizen
//
//  Created by Noah Johnson on 9/20/22.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

enum StepDuration: Int {
    case thirtySeconds = 30
    case oneMinute = 60
    case oneAndHalf = 90
    case twoMinutes = 120
}

struct Step: Identifiable, Hashable {
    var id = UUID()
    var title: String
}

struct AddMeditation: View {
    let store: StoreOf<Meditate>
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var stepDuration: StepDuration = .oneMinute
    
    @State private var steps: [Step] = [Step(title: "First"), Step(title: "Second")]
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
                    Section("Basic Info") {
                        TextField("Name", text: $name)
                        TextField("Description", text: $description,  axis: .vertical)
                            .lineLimit(5...10)
                        
                        if let selectedImageData = viewStore.selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(8.0)
                                .padding()
                            
                        }
                        
                        PhotosPicker((viewStore.selectedImageData != nil) ? "Change Image" : "Select Image", selection: $selectedItem, matching: .images)
                        
                    }
                    
                    Section("Meditation Steps") {
                        NavigationLink {
                            MeditationStepList(steps: $steps)
                        } label: {
                            Text("\(steps.count) Steps")
                        }
                        
                        Picker("Step Duration", selection: $stepDuration) {
                            Text("30 sec").tag(StepDuration.thirtySeconds)
                            Text("1 min").tag(StepDuration.oneMinute)
                            Text("1 min 30 sec").tag(StepDuration.oneAndHalf)
                            Text("2 min").tag(StepDuration.twoMinutes)
                        }
                    }
                    
                    Button("Save") {
                        viewStore.send(.saveNewMeditationButtonTapped(
                            Meditation(
                                name: name,
                                stepDuration: stepDuration.rawValue,
                                steps:  (1...steps.count).map { "Step \($0)" },
                                description: description
                            )
                        ))
                    }
                    
                    .onChange(of: selectedItem) { newItem in
                        viewStore.send(.updateImageData(newItem))
                    }
                }
            }
        }
        
    }
}



struct AddMeditation_Previews: PreviewProvider {
    static var previews: some View {
        AddMeditation(store: Store(
            initialState: Meditate.State(meditations: []),
            reducer: Meditate()
        ))
    }
}
