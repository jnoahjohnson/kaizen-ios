//
//  LoadedImage.swift
//  Kaizen
//
//  Created by Noah Johnson on 9/30/22.
//

import SwiftUI

struct LoadedImage: View {
    var imagePath: String
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    
            } else {
                Rectangle()
                    .background(.blue.gradient)
            }
        }
        
        .task {
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            guard let imageURL = directory.appendingPathComponent(imagePath) else {
                return
            }
            guard let image = UIImage(contentsOfFile: imageURL.path) else {
                return
            }
            
            self.image = image
        }
        
        
    }
}

struct LoadedImage_Previews: PreviewProvider {
    static var previews: some View {
        LoadedImage(imagePath: "fileName.png")
    }
}
