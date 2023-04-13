//
//  User.swift
//  SwifuiTest
//
//  Created by maahika gupta on 4/3/23.
//
import ObjectBox
import Foundation
import CoreLocation
import MapKit


class User: Entity {
    //for database
    var id: Id = 0
    //let store = try Store(directoryPath: "/Users/maahikagupta/Documents/ValorSmartGlasses/")
    
    required init() {
        // no properties, so nothing to do here, ObjectBox calls this
    }
    
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    var policeID: Int = 0 //username for app
    var locX: Float = 0.0
    var locY: Float = 0.0
    //var curLocationL: MKCoordinateRegion?? = nil
    
    
    /*static func allUsers() -> [User] {
        let box = try! store.box(for: User.self)
        return try! box.all()
    }
    
    func save() {
        let box = try! store.box(for: User.self)
        try! box.put(self)
    }
    
    var firstName: String {
        get {
            return _firstName
        }
        set {
            _firstName = newValue
        }
    }
        
    var lastName: String {
        get {
            return _lastName
        }
        set {
            _lastName = newValue
        }
    }*/
    
}
