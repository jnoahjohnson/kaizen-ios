//
//  MeditateCard.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI

struct MeditateCard: View {
    var meditation: Meditation
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if (meditation.builtIn) {
                Image(meditation.coverImagePath)
                    .resizable()
                    .scaledToFill()
                    .brightness(-0.2)
                    .frame(maxWidth: .infinity, maxHeight: 220.0)
            } else {
                LoadedImage(imagePath: meditation.coverImagePath)
                    .brightness(-0.2)
                    .frame(maxWidth: .infinity, maxHeight: 220.0)
            }
           


            VStack(alignment: .leading) {
                Text(meditation.name)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .shadow(radius: 8.0)
                
                HStack {
                    HStack {
                        Image(systemName: "clock.fill")
                            .imageScale(.small)
                            .foregroundColor(Color(hue: 0, saturation: 0, brightness: 12, opacity: 0.08))
                        
                        Text(meditation.durationDescription)
                            .font(.callout)
                            .foregroundColor(Color(hue: 0, saturation: 0, brightness: 12, opacity: 0.08))
                    }
                }
                    
            }
            .padding()
 
            
        }
        .frame(minWidth: 0.0, maxWidth: .infinity, minHeight: 220.0, maxHeight: 220.0)
        .cornerRadius(8.0)
       
        
    }
}

struct MeditateCard_Previews: PreviewProvider {
    static var previews: some View {
        MeditateCard(meditation: .defaultInstance)
            .padding()
    }
}
