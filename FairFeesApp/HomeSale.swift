//
//  HomeSale.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-06.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeSale: Sale {
    
    var bedroomNumber: Int!
    var bathroomNumber: Int!
   
 
    init(name:String,
         
         description:String,
         location:CLLocation,
         address: String,
         poster:User,
         photos:[UIImage],
         size: Int,
         bedroomNumber: Int,
         bathroomNumber: Int,
         UID:String?,
         price: Int,
         owner: User,
         availabilityDate: Date) {
        
        super.init()
        
        super.name = name
        super.listingDescription = description
        super.location = location
        super.address = address
        super.poster = poster
        super.size = size
        super.photos = photos
        
        super.owner = owner
        super.price = price
        super.availabilityDate = availabilityDate
        
        self.bedroomNumber = bathroomNumber
        self.bathroomNumber = bedroomNumber
        
        if (UID == nil){
            super.UID = UUID().uuidString
        }
        else {
            super.UID = UID!
        }
    }
    
}
