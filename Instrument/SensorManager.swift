//
//  SensorManager.swift
//  Instrument
//
//  Created by Wenjin Zhang on 10/15/21.
//



import SwiftUI

import Combine
import Foundation

import CoreMotion
import CoreLocation


// TODO change height -> altitude
class AltimatorManager: NSObject, ObservableObject {
    let willChange = PassthroughSubject<Void, Never>()
    
    var altimeter:CMAltimeter?
    
    // atm, meter, meter
    @Published var pressureDouble:Double = 0
    @Published var absoluteAltitudeDouble:Double = 0
    @Published var relativeAltitudeDouble:Double = 0
    @Published var referenceAltitudeDouble:Double = 0
    
    @Published var verticalSpeed:Double = 0
    @Published var lastReportedTimeStamp:Double = 0
    
    var temperature = 23.0
    
    var basePressure = 101.325
    var baseHeight = 0.00001
    
    override init() {
        super.init()
        altimeter = CMAltimeter()
        startUpdate()
    }
    
    func setTemperature(t:Double){
        temperature = t
    }
    
    func setBasePressure(bp:Double){
        basePressure = bp
        baseHeight = calculateHeight(p:bp)
        // print(bp, baseHeight)
    }
    
    func calculateHeight(p:Double) -> Double {
        let ratio1 = 101.325/p
        let ratio2 = 1/5.257
        let power = pow(ratio1, ratio2)
        
        let res = (power-1)*(self.temperature+273.15)/0.0065
        
        // let res = (pow(101.325/p, 1/5.257)-1)*(temperature+273.15)/0.0065
        return res
    }
    
    func doReset(){
        setBasePressure(bp:pressureDouble*101.325)
        altimeter?.stopRelativeAltitudeUpdates()
        startUpdate()
    }
    
    func startUpdate() {
        if(CMAltimeter.isRelativeAltitudeAvailable()) {
            altimeter!.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler:
                {data, error in
                    if error == nil {
                        let pressure:Double = data!.pressure.doubleValue
                        let altitude:Double = data!.relativeAltitude.doubleValue
                        
                        let now = NSDate().timeIntervalSince1970
                        self.verticalSpeed = (altitude - self.relativeAltitudeDouble) / (now-self.lastReportedTimeStamp)
                        self.lastReportedTimeStamp = now
                        
                        self.pressureDouble = pressure / 101.325
                        self.relativeAltitudeDouble = altitude
                        self.absoluteAltitudeDouble = self.calculateHeight(p:pressure)
                        self.referenceAltitudeDouble = self.absoluteAltitudeDouble - self.baseHeight
                        
                        // print(pressure, self.absoluteAltitudeDouble)
                        self.willChange.send()
                    }
            })
        }
        

    }

}




class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate {
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    var heading: Double = .zero {
        didSet {
            objectWillChange.send()
        }
    }

    
    let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.setup()
    }
    
    private func setup() {
        // self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = -1 * newHeading.magneticHeading
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        // print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        // print(#function, location)
    }
}


class CoreMotionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let willChange = PassthroughSubject<Void, Never>()
    
    @Published var accelerationX:Double = 0
    @Published var accelerationY:Double = 0
    @Published var accelerationZ:Double = 0
    
    
    
    var degrees: Double = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    private let coreMotionManager: CMMotionManager
    
    override init() {
        self.coreMotionManager = CMMotionManager()
        super.init()

        self.setup()
    }
    
    private func setup() {
    
        coreMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler:
            {data, error in
                if error == nil {
                    self.accelerationX = data!.acceleration.x
                    self.accelerationY = data!.acceleration.y
                    self.accelerationZ = data!.acceleration.z
                    
                    self.willChange.send()
                }
        })
        
        
    }
    

}




