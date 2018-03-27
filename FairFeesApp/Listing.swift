//
//  Listing.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps

class Listing: GMSMarker, MKAnnotation  {
    
    var coordinate: CLLocationCoordinate2D {
        get { return self.location.coordinate }
    }
    
    var UID: String!
    var name: String!
    var posterUID: String!
    var listingDescription: String!
    var photos: [UIImage]!
    var photoRefs: [String]!
    var size: Int!
    var location: CLLocation!
    var address: String!
    var city: String!
    var province: String!
    var country: String!
    var zipcode: String!
    var active: Bool!
    
}
