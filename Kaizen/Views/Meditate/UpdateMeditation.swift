//
//  UpdateMeditation.swift
//  Kaizen
//
//  Created by Noah Johnson on 11/28/22.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

struct UpdateMeditation: View {
    let store: StoreOf<Meditate>
    let meditationId: UUID
    
    @State var name: String
    @State var description: String
    @State var selectedItem: PhotosPickerItem? = nil
    @State var stepDuration: StepDuration
    @State private var steps: [Step]
    
    init(store: StoreOf<Meditate>, meditationId: UUID, name: String, description: String, stepDuration: StepDuration, steps: [Step]) {
        print("Name", name)
        self.store = store
        self.meditationId = meditationId
        _name = State(initialValue: name)
        _description = State(initialValue: description)
        _stepDuration = State(initialValue: stepDuration)
        _steps = State(initialValue: steps)
    }
    
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
                    
                    Button("Update") {
                        viewStore.send(.updateMeditationTapped(
                            UpdateMeditationData(
                                id: self.meditationId,
                                name: self.name,
                                stepDuration: self.stepDuration.rawValue,
                                steps: self.steps.map { $0.title },
                                description: self.description
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

struct UpdateMeditation_Previews: PreviewProvider {
    static var previews: some View {
        UpdateMeditation(store: Store(
            initialState: Meditate.State(meditations: []),
            reducer: Meditate()), meditationId: UUID(), name: "Meditation", description: "Description", stepDuration: StepDuration(rawValue: 60) ?? .oneMinute, steps: [Step(title: "Test")])
    }
}
