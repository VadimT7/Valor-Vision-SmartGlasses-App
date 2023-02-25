//
//  Location.swift
//  SwifuiTest
//
//  Created by maahika gupta on 12/28/22.
//

import Foundation
import CoreLocation
import ActiveLookSDK


struct Location: Identifiable, Codable, Equatable{
    var id: UUID
    var name: String
    var discription: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static let example = Location(id: UUID(), name: "home", discription: "my home", latitude: 100, longitude: 100)
    
    static func ==(lhs: Location, rhs: Location) -> Bool{
        lhs.id == rhs.id
    }
}
