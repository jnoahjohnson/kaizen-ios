//
//  MeditationPage.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI
import ComposableArchitecture

struct MeditationPage: View {
    @ObservedObject var viewModel: MeditationViewModel
    let store: ViewStoreOf<Meditate>
    @Environment(\.scenePhase) var scenePhase
    
    
    init(meditation: Meditation, store: ViewStoreOf<Meditate>, onClose: @escaping () -> Void) {
        self.viewModel = MeditationViewModel(meditation: meditation, store: store, onClose: onClose)
        self.store = store
        UIApplication.shared.isIdleTimerDisabled = true
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
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
        
    }
}

struct MeditationPage_Previews: PreviewProvider {
    static let store = Store(
        initialState: Meditate.State(meditations: [.defaultInstance]),
        reducer: Meditate()
    )
    static let viewStore = ViewStore(store)
    
    static let viewModel = MeditationViewModel(meditation: .defaultInstance, store: viewStore, onClose: { })
    
    static var previews: some View {
        NavigationStack {
            MeditationPage(meditation: self.viewModel.meditation, store: viewStore, onClose: { })
        }
    }
}
