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
    
    var homeBedroomNumber: Int!
    var homeBathroomNumber: Int!
   
 
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
        
        super.listingName = name
        super.listingDescription = description
        super.listingLocation = location
        super.listingAddress = address
        super.listingPoster = poster
        super.listingSize = size
        super.listingPhotos = photos
        
        super.saleOwner = owner
        super.salePrice = price
        super.saleAvailabilityDate = availabilityDate
        
        self.homeBedroomNumber = bathroomNumber
        self.homeBathroomNumber = bedroomNumber
        
        if (UID == nil){
            super.listingUID = UUID().uuidString
        }
        else {
            super.listingUID = UID!
        }
    }
    
}
