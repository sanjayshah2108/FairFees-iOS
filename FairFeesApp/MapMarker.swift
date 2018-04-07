//
//  MapMarker.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import GoogleMaps


class MapMarker: NSObject, GMUClusterItem {
    
    var position: CLLocationCoordinate2D
    var name: String!
    @objc var marker: GMSMarker!
    
    init(position: CLLocationCoordinate2D, name: String, marker: GMSMarker) {
        self.position = position
        self.name = name
        self.marker = marker
    }

}
