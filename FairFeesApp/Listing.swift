//
//  Listing.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import CoreLocation

class Listing: NSObject {
    
    var listingUID: String!
    var listingName: String!
    var listingPoster: User!
    var listingDescription: String!
    var listingPhotos: [UIImage]!
    var listingSize: Int!
    var listingLocation: CLLocation!
    
}
