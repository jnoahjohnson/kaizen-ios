//
//  MeditationStore.swift
//  Kaizen
//
//  Created by Noah Johnson on 9/11/22.
//

import Foundation

class MeditationStore: ObservableObject {
    @Published var meditations: [Meditation] = []
    
    init() {
        MeditationStore.load { result in
            switch result {
            case .failure(_):
                MeditationStore.save(meditations: [.defaultInstance], completion: { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case.success(_):
                        print("Saved")
                    }
                })
                
                self.meditations = [.defaultInstance]
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
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("meditations.data")
    }
    
    static func load(completion: @escaping (Result<[Meditation], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let meditations = try JSONDecoder().decode([Meditation].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(meditations))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(meditations: [Meditation], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(meditations)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(meditations.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
