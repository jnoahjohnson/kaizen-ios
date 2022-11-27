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

struct AddMeditation: View {
    let store: StoreOf<Meditate>
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @State private var numSteps: Int = 1
    @State private var steps: [String] = []
    @State private var stepDuration: StepDuration = .oneMinute
    
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description,  axis: .vertical)
                        .lineLimit(5...10)
                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(8.0)
                            .padding()
                        
                    }
                    PhotosPicker((selectedImageData != nil) ? "Change Image" : "Select Image", selection: $selectedItem, matching: .images)
                    
                }
                
                Section("Meditation Steps") {
                    Stepper("Steps: \(numSteps)", value: $numSteps, in: 1...10)
                    Picker("Step Duration", selection: $stepDuration) {
                        Text("30 sec").tag(StepDuration.thirtySeconds)
                        Text("1 min").tag(StepDuration.oneMinute)
                        Text("1 min 30 sec").tag(StepDuration.oneAndHalf)
                        Text("2 min").tag(StepDuration.twoMinutes)
                    }
                }
                
                Button("Save") {
                    guard let selectedImageData else { return }
                    
                    let newMeditation = Meditation(
                        name: name,
                        stepDuration: stepDuration.rawValue,
                        steps:  (1...numSteps).map { "Step \($0)" },
                        description: description
                    )
                        
                    viewStore.send(.saveNewMeditationButtonTapped(newMeditation, selectedImageData))
                }
                
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            withAnimation {
                                selectedImageData = data
                            }
                        }
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
