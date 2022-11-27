//
//  MeditationPage.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI

struct MeditationPage: View {
    @ObservedObject var viewModel: MeditationViewModel
    
    init(meditation: Meditation, onClose: @escaping () -> Void) {
        self.viewModel = MeditationViewModel(meditation: meditation, onClose: onClose)
    }
    
    var body: some View {
        VStack{
            Spacer()
            ZStack(alignment: .center) {
                VStack {
                    Group {
                        if viewModel.hasBegun {
                            Text(viewModel.currentTitle)
                                .font(.title2.weight(.light).smallCaps())
                            
                            Text(viewModel.timeLeft)
                                .font(.largeTitle.bold())
                                .padding(.bottom, 4)
                        }
                    }
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 1.0)))
                    .animation(.easeIn, value: viewModel.hasBegun)
                    
                    Button {
                        if viewModel.isPlaying {
                            viewModel.pauseTimer()
                        } else {
                            viewModel.startTimer()
                        }
                    } label: {
                        Text(viewModel.isPlaying ? "Pause" : "Play")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
            
                }
                
                ProgressCircle(progress: $viewModel.progress)
                
            }
            
            Spacer()
            
            HStack {
                Button {
                    viewModel.prevStep()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 32.0))
                }
                .disabled(viewModel.isFirstStep)
                
                Group {
           
                    Spacer()
                    
                    if (viewModel.isLastStep) {
                        Button("Finish") {
                            viewModel.finishMeditation()
                        }
                    } else {
                        Button("Cancel") {
                            viewModel.cancel()
                        }
                    }
                    
                    Spacer()
                    
                }
                
                Button {
                    viewModel.nextStep()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 32.0))
                }
                .disabled(viewModel.isLastStep)
            }
            .padding(.horizontal, 48)
        }
      
        .padding()
        
        
        .navigationBarBackButtonHidden()
        .navigationTitle(viewModel.meditation.name)
        
    }
}

struct MeditationPage_Previews: PreviewProvider {
    static let viewModel = MeditationViewModel(meditation: .defaultInstance, onClose: { })
    
    static var previews: some View {
        NavigationStack {
            MeditationPage(meditation: self.viewModel.meditation, onClose: { })
        }
    }
}
