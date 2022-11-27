//
//  MeditateReducer.swift
//  Kaizen
//
//  Created by Noah Johnson on 11/26/22.
//


import ComposableArchitecture
import Foundation
import SwiftUI
import PhotosUI

func fileURL() throws -> URL {
    try FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: false
    )
    .appendingPathComponent("meditations.data")
}


enum UpdateImageError: Error {
    case loadTransferableError
}


struct Meditation: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var coverImagePath: String = ""
    var stepDuration: Int = 30
    var steps: [String] = []
    var description: String?
    var durationDescription: String {
        let interval = self.steps.count * self.stepDuration
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        
        let formattedString = formatter.string(from: TimeInterval(interval))!
        return formattedString
    }
    var builtIn: Bool = false
    
    static let defaultInstance = Meditation(name: "8 Sense", coverImagePath: "beach", stepDuration: 90, steps: ["Sight", "Breath", "Touch", "Taste"], builtIn: true)
}

enum AddMeditationPages {
    case stepPage, confirmPage
}

struct Meditate: ReducerProtocol {
    struct State: Equatable {
        var meditations: [Meditation]
        var addMeditationNavStack: [AddMeditationPages] = []
        var showAddMeditation: Bool = false
        
        var newMeditation: Meditation? = nil
        var selectedImageData: Data? = nil
    }
    
    enum Action: Equatable {
        case addMeditation(Meditation)
        case loadMeditations
        case saveMeditations
        case loadMeditationResult(TaskResult<[Meditation]>)
        case meditationNavStackChanged([AddMeditationPages])
        case navigateAddMeditation(AddMeditationPages)
        case saveNewMeditationButtonTapped(Meditation)
        case updateShowAddMeditation(Bool)
        case saveImageResponse(TaskResult<String>)
        case updateImageData(PhotosPickerItem?)
        case updateImageResponse(TaskResult<Data>)
    }
    
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .addMeditation(meditation):
            state.meditations.append(meditation)
            
            return .run { send in
                await send(.saveMeditations)
            }
            
        case .loadMeditations:
            return .task {
                await .loadMeditationResult (
                    TaskResult {
                        let fileURL = try fileURL()
                        
                        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                            return []
                            
                        }
                        
                        let meditations = try JSONDecoder().decode([Meditation].self, from: file.availableData)
                        
                        return meditations
                    }
                )
            }
            
        case let .loadMeditationResult(.success(meditations)):
            state.meditations = meditations
            return .none
            
        case .loadMeditationResult(.failure):
            print("Yeah... that didn't work")
            return .none
            
        case .saveMeditations:
            do {
                let data = try JSONEncoder().encode(state.meditations)
                let outfile = try fileURL()
                try data.write(to: outfile)
                
            } catch {
                print("Error")
            }
            
            return .none
            
        case let .meditationNavStackChanged(meditations):
            state.addMeditationNavStack = meditations
            
            return .none
            
            
        case let .navigateAddMeditation(page):
            state.addMeditationNavStack.append(page)
            
            return .none
            
        case let .updateShowAddMeditation(newShow):
            state.showAddMeditation = newShow
            
            return .none
            
            
        case let .saveNewMeditationButtonTapped(meditation):
            guard let imageData = state.selectedImageData else { return .none }
            
            state.newMeditation = meditation
            
            return .task {
                await .saveImageResponse(
                    TaskResult {
                        guard let newImage = UIImage(data: imageData) else { return "" }
                        guard let data = newImage.jpegData(compressionQuality: 1) ?? newImage.pngData() else { return "" }
                        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return "" }
                        
                        do {
                            let imageName = String.uniqueFilename(withPrefix: "image") + ".png"
                            
                            try data.write(to: directory.appendingPathComponent(imageName))
                            
                            return imageName
                            
                        } catch {
                            print(error.localizedDescription)
                            return ""
                        }
                    }
                )
            }
            
        case let .saveImageResponse(.success(newImage)):
            guard let meditation = state.newMeditation else { return .none }
            
            return .concatenate([
                .run { send in
                    await send(.addMeditation(
                        Meditation(
                            name: meditation.name,
                            coverImagePath: newImage,
                            stepDuration: meditation.stepDuration,
                            steps: meditation.steps,
                            description: meditation.description
                        )
                    ))
                },
                .run { send in
                    await send(.updateShowAddMeditation(false))
                }
            ])
            
        case .saveImageResponse(.failure):
            print("Problem saving")
            
            return .none
            
        case let .updateImageData(selectedPhoto):
            guard let selectedPhoto else { return .none }
            
            
            return .task {
                await .updateImageResponse(
                    TaskResult {
                        if let data = try? await selectedPhoto.loadTransferable(type: Data.self) {
                            return data
                        }
                        
                        throw UpdateImageError.loadTransferableError
                    }
                )
            }
            
        case let .updateImageResponse(.success(data)):
            withAnimation {
                state.selectedImageData = data
            }
            
            return .none
            
        case .updateImageResponse(.failure):
            print("Issue with update image response")
            
            return .none
           
        }
    }
}
