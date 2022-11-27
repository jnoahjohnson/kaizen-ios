//
//  ProgressCircle.swift
//  Kaizen
//
//  Created by Noah Johnson on 6/14/22.
//

import SwiftUI

struct ProgressCircle: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.blue)
                .padding()
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: -90))
                .foregroundColor(Color.blue)
                .animation(.linear(duration: self.progress > 0.98 ? 0.5 : 1.0), value: self.progress)
                .padding()
        }
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle(progress: .constant(0.3))
    }
}
