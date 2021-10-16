//
//  SensorView.swift
//  Instrument
//
//  Created by Wenjin Zhang on 10/15/21.
//

import SwiftUI

import CoreMotion


struct SensorView: View {
    
    @ObservedObject var manager = AltimatorManager()
    @ObservedObject var manager2 = CompassHeading()
    @ObservedObject var manager3 = CoreMotionManager()
    
    @StateObject var locationManager = LocationManager()
    

    let availabe = CMAltimeter.isRelativeAltitudeAvailable()

    var body: some View {
        VStack(spacing: 30) {
            
            VStack(spacing: 30) {
                
                Spacer()
                
                Text("Version: V1.0.6")
                
                Spacer()
                
                Text(availabe ? String(format: "Pressure: %.4f ATM", manager.pressureDouble) : "----")
                
                Text(availabe ? String(format: "AbsAlt: %.0f ft", manager.absoluteAltitudeDouble * 3.28) : "----")
                Text(availabe ? String(format: "RelAlt: %.0f ft", manager.relativeAltitudeDouble * 3.28) : "----")
                
                Text(availabe ? String(format: "RefAlt: %.2f+", manager.baseHeight*3.28)+String(format: "%.2f ft", manager.referenceAltitudeDouble * 3.28) : "----")
                
                Button(action: {
                    self.manager.doReset()
                }) {
                    Text("SetRefAlt")
                }

                Text(availabe ? String(format: "VS: %.2f m/s", manager.verticalSpeed) : "----")
                
            }
             
            VStack(spacing: 30) {
                Text(String(format: "Heading: %.2f", manager2.heading))
                

                VStack(spacing: 30) {
                    HStack{
                        Text(String(format: "latitude: %.2f ",  (locationManager.lastLocation?.coordinate.latitude ?? 0)))
                        Text(String(format: "longitude: %.2f ", (locationManager.lastLocation?.coordinate.longitude ?? 0)))
                    }
                    
                    HStack{
                        Text(String(format: "Speed: %.2f m/s", (locationManager.lastLocation?.speed ?? 0)))
                        Text(String(format: "Course: %.2f", (locationManager.lastLocation?.course ?? 0)))
                    }
                    
                    
                }
                
            }
            
            HStack(spacing: 30) {
                Text(String(format: "X: %0.2f", manager3.accelerationX))
                Text(String(format: "Y: %0.2f", manager3.accelerationY))
                Text(String(format: "Z: %0.2f", manager3.accelerationZ))
            }
            
            Spacer()

            
        }
    }
}




struct SensorView_Previews: PreviewProvider {
    static var previews: some View {
        SensorView()
    }
}
