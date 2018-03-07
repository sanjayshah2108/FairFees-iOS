//
//  DummyData.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-06.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class DummyData: NSObject {
    
    static let theDummyData = DummyData()

    var users: [User]!
    var homesForSale: [HomeSale]!
    
    let date = Date()
    
    func createUsers(){
        
        users = []
        
        let user1 = User(firstName: "Sanjay", lastName: "Shah", email: "sanjays@gmail.com", phoneNumber: 7788816399, rating: 5, listings: [], UID: nil)
        
        let user2 = User(firstName: "Test", lastName: "Owner", email: "sanjays@gmail.com", phoneNumber: 7788816399, rating: 5, listings: [], UID: nil)
        
        self.users.append(user1)
        self.users.append(user2)
    }
    
    func createListings(){

        homesForSale = []
        LocationManager.theLocationManager.currentLocation = LocationManager.theLocationManager.getLocation()
        
        let homeSale1 = HomeSale(name: "North Van Apt", description: "", location: LocationManager.theLocationManager.currentLocation, poster: users[0], photos: [], size: 30, bedroomNumber: 2, bathroomNumber: 2, UID: nil, price: 300000, owner: users[1], availabilityDate: Date())
        
        let homeSale2 = HomeSale(name: "West Van Apt", description: "", location: LocationManager.theLocationManager.currentLocation, poster: users[0], photos: [], size: 30, bedroomNumber: 2, bathroomNumber: 2, UID: nil, price: 300000, owner: users[1], availabilityDate: Date())
        
        let homeSale3 = HomeSale(name: "Downtown Apt", description: "", location: LocationManager.theLocationManager.currentLocation, poster: users[0], photos: [], size: 30, bedroomNumber: 2, bathroomNumber: 2, UID: nil, price: 300000, owner: users[1], availabilityDate: Date())
        
        let homeSale4 = HomeSale(name: "East Van House", description: "", location: LocationManager.theLocationManager.currentLocation, poster: users[0], photos: [], size: 30, bedroomNumber: 2, bathroomNumber: 2, UID: nil, price: 300000, owner: users[1], availabilityDate: Date())
        
        let homeSale5 = HomeSale(name: "Vancouver West Apt", description: "", location: LocationManager.theLocationManager.currentLocation, poster: users[0], photos: [], size: 30, bedroomNumber: 2, bathroomNumber: 2, UID: nil, price: 300000, owner: users[1], availabilityDate: Date())
        
        homesForSale.append(homeSale1)
        homesForSale.append(homeSale2)
        homesForSale.append(homeSale3)
        homesForSale.append(homeSale4)
        homesForSale.append(homeSale5)
        
    }
    
    
}
