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
         city: String,
         province: String,
         country: String,
         zipcode: String,
         posterUID:String,
         photosRef:[String],
         size: Int,
         bedroomNumber: Int,
         bathroomNumber: Int,
         UID:String?,
         price: Int,
         ownerUID: String,
         availabilityDate: NSNumber) {
        
        super.init()
        
        super.name = name
        super.listingDescription = description
        super.location = location
        super.address = address
        super.city = city
        super.province = province
        super.country = country
        super.zipcode = zipcode
        super.posterUID = posterUID
        super.size = size
        //super.photos = photos
        super.photosRefs = photosRef
        super.ownerUID = ownerUID
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
    
    
    
    convenience init?(with inpDict:[String:Any]) {
        
        guard
            let inpName: String = inpDict["name"] as? String,
            let inpDescription: String = inpDict["description"] as? String,
            let inpAddress: String = inpDict["address"] as? String,
            let inpCity: String = inpDict["city"] as? String,
            let inpProvince: String = inpDict["province"] as? String,
            let inpCountry: String = inpDict["country"] as? String,
            let inpZipcode: String = inpDict["zipcode"] as? String,
            let inpUID: String = inpDict["UID"] as? String,
            let inpPosterUID: String = inpDict["posterUID"] as? String,
            let inpSize: Int = inpDict["size"] as? Int,
            let inpBedroomNumber: Int =  inpDict["bedroomNumber"] as? Int,
            let inpLocationDict: [String:Double] = inpDict["location"] as? [String:Double],
            let inpBathroomNumber: Int = inpDict["bathroomNumer"] as? Int,
            let inpPrice: Int = inpDict["price"] as? Int,
            let inpAvailabilityDate: NSNumber = inpDict["availabilityDate"] as! NSNumber,
            let inpPhotos: [String] = inpDict["photos"] as? [String],
            let inpOwnerUID: String = inpDict["ownerUID"] as? String else
        {
            print("Error: Dictionary is not in the correct format")
            return nil
        }
        
        guard
            let inpLatitude: Double = inpLocationDict["latitude"],
            let inpLongitude: Double = inpLocationDict["longitude"] else
        {
            print("Error: Passed location data is not in the correct format")
            return nil
        }
        
        let inpLocation: CLLocation = CLLocation(latitude: inpLatitude, longitude: inpLongitude)
        
        
        self.init(name: inpName, description: inpDescription, location: inpLocation, address: inpAddress, city: inpCity, province: inpProvince, country: inpCountry, zipcode: inpZipcode, posterUID: inpPosterUID, photosRef: inpPhotos, size: inpSize, bedroomNumber: inpBedroomNumber, bathroomNumber: inpBathroomNumber, UID: inpUID, price: inpPrice, ownerUID: inpOwnerUID, availabilityDate: inpAvailabilityDate)
        
    }
    
    func toDictionary() -> [String:Any] {
        let locationDict:[String:Double] = ["latitude":self.location.coordinate.latitude , "longitude":self.location.coordinate.longitude]
        
        let itemDict:[String:Any] = [
            "UID": super.UID,
            "name": super.name,
            "address": super.address,
            "city" : super.city,
            "province" : super.province,
            "country": super.country,
            "zipcode" : super.zipcode,
            "description": super.listingDescription,
            "location": locationDict,
            "posterUID":super.posterUID,
            "photos":self.photos,
            "size" : super.size,
            "price": super.price,
            "bedroomNumber": self.bedroomNumber,
            "bathroomNumber": self.bathroomNumber,
            "ownerUID": super.ownerUID,
            "availabilityDate" :super.availabilityDate
            
        ]
        
        return itemDict
    }
    
}
