//
//  Journal.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI

struct Journal: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading) {
                        Section {
                            ScrollView(.horizontal) {
                                
                                HStack {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.blue.gradient)
                                            .frame(width: geo.size.width / 2, height: 96)
                                            .cornerRadius(8.0)
                                            .shadow(radius: 4.0)
                                        
                                        VStack {
                                            Image(systemName: "doc")
                                                .foregroundColor(.white)
                                            
                                            Text("Blank")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20.0)).bold()
                                        }
                                    }
                                }
                            }
                            
                        } header: {
                            Text("New Entry")
                                .font(.headline)
                        }
                        
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct Journal_Previews: PreviewProvider {
    static var previews: some View {
        Journal()
    }
}
