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

class Listing: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        get { return self.location.coordinate }
        //set { self.listingLocation.coordinate = newValue }
    }
    
    var UID: String!
    var name: String!
    var poster: User!
    var listingDescription: String!
    var photos: [UIImage]!
    var size: Int!
    var location: CLLocation!
    var address: String!
    
}
