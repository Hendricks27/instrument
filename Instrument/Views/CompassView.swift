//
//  CompassView.swift
//  Instrument
//
//  Created by Wenjin Zhang on 10/15/21.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

        return path
    }
}

struct CompassView: View {
    
    @ObservedObject var manager2 = CompassHeading()
    
    
    var body: some View {
        
        ZStack {
            Color.gray.ignoresSafeArea()
            
            VStack{
                
                Triangle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 30)
        
                Image("co")
                    .resizable()
                    .frame(width: 300.0, height: 300.0)
                    .rotationEffect(.degrees(manager2.heading))
                
            }
        }
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}
