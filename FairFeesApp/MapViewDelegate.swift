//
//  MapViewDelegate.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    
    static let theMapViewDelegate = MapViewDelegate()

    weak var theMapView: MKMapView!
    weak var myLocation: CLLocation! = LocationManager.theLocationManager.getLocation()
    
    func setMapRegion(){
        
        let span = MKCoordinateSpanMake(0.009, 0.009)
        theMapView.setRegion(MKCoordinateRegionMake(myLocation.coordinate, span) , animated: true)
    }

}
