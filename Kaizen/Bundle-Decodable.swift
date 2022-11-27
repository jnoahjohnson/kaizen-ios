//
//  Bundle-Decodable.swift
//  Kaizen
//
//  Created by Noah Johnson on 9/11/22.
//
import Foundation

extension Bundle {
    func decode(_ file: String) -> [String: Meditation] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode([String: Meditation].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
