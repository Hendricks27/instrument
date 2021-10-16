//
//  ContentView.swift
//  Instrument
//
//  Created by Wenjin Zhang on 10/15/21.
//

import SwiftUI

import Combine
import Foundation

import CoreMotion
import CoreLocation




struct ContentView: View {
    
    @State var selectedViewNum: Int = 0

    var body: some View {
        
        TabView(selection: self.$selectedViewNum){
            CompassView().tag(0)
            PFDView().tag(1)
            MFDView().tag(2)
            SensorView().tag(3)
            SettingView().tag(4)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        
        
        // Bottom Navigation bar
        HStack(){
            
            Button(action: {
                self.selectedViewNum = 0
            }) {
                Text("Compass")
            }
            .padding()
            //.background(Color(red: 0, green: 0, blue: 0.5))
            
            
            Button(action: {
                self.selectedViewNum = 1
            }) {
                Text("PFD")
            }
            .padding()

            
            Button(action: {
                self.selectedViewNum = 2
            }) {
                Text("MFD")
            }
            .padding()

            
            Button(action: {
                self.selectedViewNum = 3
            }) {
                Text("Sensor")
            }
            .padding()

            Button(action: {
                self.selectedViewNum = 4
            }) {
                Text("Settings")
            }
            .padding()

            
            
        }
        

    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        
    }
}





