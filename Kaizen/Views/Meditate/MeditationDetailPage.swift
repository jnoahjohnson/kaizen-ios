//
//  MeditationPage.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI

struct MeditationDetailPage: View {
    var meditation: Meditation
    var onMeditate: () -> Void
    var onClose: () -> Void
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        ZStack(alignment: .topTrailing) {
                           
                            ZStack(alignment: .bottomLeading) {
                                if (meditation.builtIn) {
                                    Image(meditation.coverImagePath)
                                        .resizable()
                                        .scaledToFill()
                                        .brightness(-0.2)
                                        .frame(height: geometry.size.height * 0.4)
                                        .clipped()
                                } else {
                                    LoadedImage(imagePath: meditation.coverImagePath)
                                        .brightness(-0.2)
                                        .frame(height: geometry.size.height * 0.4)
                                        .clipped()
                                }
                                
                                
                                Text(meditation.name)
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.white)
                                    .padding()
                                    .shadow(radius: 8.0)
                            }
                        }
                        .frame(height: geometry.size.height * 0.4)
                        
                        Text(meditation.description ?? "")
                            .padding(.horizontal)
                            .padding(.bottom, 62)
                        
                    }
                    
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .font(.system(size: 28))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
            } //close geometry reader
            .edgesIgnoringSafeArea(.top)
            
            Button {
                // Start Meditation
                onMeditate()
            } label: {
                Text("Start Meditation")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    .shadow(color: .secondary, radius: 3)
            }
            
        }
        
    }
    
}

struct MeditationDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MeditationDetailPage(meditation: .defaultInstance, onMeditate: { }, onClose: { })
        }
    }
}
