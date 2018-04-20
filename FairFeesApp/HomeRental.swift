//
//  HomeRental.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-22.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import CoreLocation

class HomeRental: Rental {

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
         photoRefs:[String],
         size: Int,
         bedroomNumber: Int,
         bathroomNumber: Int,
         UID:String?,
         monthlyRent: Int,
         rentalTerm: Int,
         landlordUID: String,
         availabilityDate: NSNumber,
         active: Bool) {
        
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
        super.photoRefs = photoRefs
        super.landlordUID = landlordUID
        super.monthlyRent = monthlyRent
        super.availabilityDate = availabilityDate
        super.rentalTerm = rentalTerm
        super.active = active
        
        self.bedroomNumber = bathroomNumber
        self.bathroomNumber = bedroomNumber
        
        //if we are creating a new homeRental, we need to create a UID, otherwise if we are creating a homeRental from Firebase Data, there will aready be a UID
        if (UID == nil){
            super.UID = UUID().uuidString
        }
        else {
            super.UID = UID!
        }
    }
    
    
    //used when creating a homeRental from FirebaseData
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
            let inpBathroomNumber: Int = inpDict["bathroomNumber"] as? Int,
            let inpMonthlyRent: Int = inpDict["monthlyRent"] as? Int,
            let inpAvailabilityDate: NSNumber = inpDict["availabilityDate"] as? NSNumber,
            let inpRentalTerm: Int = inpDict["rentalTerm"] as? Int,
            let inpPhotoRefs: [String] = inpDict["photoRefs"] as? [String],
            let inpLandlordUID: String = inpDict["landlordUID"] as? String,
            let inpIsActive: Bool = inpDict["isActive"] as? Bool else
        {
            print("Error: HomeRental Dictionary is not in the correct format")
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
        
        self.init(name: inpName, description: inpDescription, location: inpLocation, address: inpAddress, city: inpCity, province: inpProvince, country: inpCountry, zipcode: inpZipcode, posterUID: inpPosterUID, photoRefs: inpPhotoRefs, size: inpSize, bedroomNumber: inpBedroomNumber, bathroomNumber: inpBathroomNumber, UID: inpUID, monthlyRent: inpMonthlyRent, rentalTerm: inpRentalTerm, landlordUID: inpLandlordUID, availabilityDate: inpAvailabilityDate, active: inpIsActive)
        
    }
    
    
    //used for writing homeRental to Firebase
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
            "photoRefs":self.photoRefs,
            "size" : super.size,
            "monthlyRent": super.monthlyRent,
            "rentalTerm" : super.rentalTerm,
            "bedroomNumber": self.bedroomNumber,
            "bathroomNumber": self.bathroomNumber,
            "landlordUID": super.landlordUID,
            "availabilityDate" :super.availabilityDate,
            "isActive" : super.active
            
        ]
        
        return itemDict
    }
}
