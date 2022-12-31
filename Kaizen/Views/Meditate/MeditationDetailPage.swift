//
//  MeditationPage.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI
import ComposableArchitecture

struct MeditationDetailPage: View {
    let store: StoreOf<Meditate>
    var meditation: Meditation
    var onMeditate: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom){
                ZStack(alignment: .topTrailing) {
                    ScrollView (.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ZStack(alignment: .topTrailing) {
                                ZStack(alignment: .bottomLeading) {
                                    if (meditation.builtIn) {
                                        Image(meditation.coverImagePath)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 240)
                                            .clipped()
                                    } else {
                                        LoadedImage(imagePath: meditation.coverImagePath)
                                            .frame(height: 240)
                                            .clipped()
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(meditation.name)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .shadow(radius: 8.0)
                                        
                                        HStack {
                                            Image(systemName: "clock.fill")
                                                .imageScale(.small)
                                                .foregroundColor(.white)
                                            
                                            Text(meditation.durationDescription)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding([.horizontal, .bottom])
                                    
                                    
                                }
                            }
                            
                            Text(meditation.description ?? "")
                                .fontWeight(.medium)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            
                            
                            
                            Text("Steps")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.leading)
                                .padding(.bottom, 1)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(self.meditation.steps, id: \.self) { step in
                                    Text(step)
                                        .font(.headline)
                                        .bold()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            
                            Text("Recent")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.leading)
                                .padding(.bottom, 1)
                            
                            if (self.meditation.meditationActivities.isEmpty) {
                                Text("No recent meditations")
                                    .padding(.leading)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(self.meditation.meditationActivities, id: \.self) { activity in
                                    Text(activity.date.formatted())
                                        .font(.headline)
                                        .bold()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            
                            NavigationLink {
                                UpdateMeditation(store: self.store, meditationId: self.meditation.id, name: self.meditation.name, description: self.meditation.description ?? "", stepDuration: StepDuration(rawValue: self.meditation.stepDuration) ?? .oneMinute, steps: self.meditation.steps.map { Step(title: $0) })
                            } label: {
                                Text("Edit Meditation")
                                    .padding(.leading)
                            }
                            
                        }
                    }
                    
                }
                
            }
            .edgesIgnoringSafeArea(.top)
            
            Button {
                onMeditate()
            } label: {
                
                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.primary)
                        .padding(.trailing, 4)
                    
                    Text("Start Meditation")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                }
                .padding(EdgeInsets(top: 18, leading: 32, bottom: 18, trailing: 32))
                .background(.thinMaterial)
                .clipShape(Capsule())
                
                
            }
            
        }
        
    }
    
}

struct MeditationDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MeditationDetailPage(store: Store(
                initialState: Meditate.State(meditations: []),
                reducer: Meditate()), meditation: .defaultInstance, onMeditate: { })
        }
    }
}
