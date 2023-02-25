//
//  CompassHeading.swift
//  SwifuiTest
//
//  Created by maahika gupta on 12/31/22.
//

import Foundation
import Combine
import CoreLocation
import CoreMotion
import ActiveLookSDK


class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate{
    var objectWillChange = PassthroughSubject<Void, Never>()
    var degrees: Double = .zero{
        didSet{
            objectWillChange.send()
        }
    }
    private let locationManager: CLLocationManager
    
    override init(){
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.setup()
    }
    
    private func setup(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.headingAvailable(){
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading){
        self.degrees = -1 * newHeading.magneticHeading
    }
}

