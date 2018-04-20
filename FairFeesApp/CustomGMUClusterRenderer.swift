//
//  GMUDefaultClusterRenderer+CustomMarkers.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import Foundation
import UIKit

//we can customize clustering with this class
class CustomGMUClusterRenderer: GMUDefaultClusterRenderer {
    var mapView:GMSMapView?
    let kGMUAnimationDuration: Double = 0.5
    
    override init(mapView: GMSMapView, clusterIconGenerator iconGenerator: GMUClusterIconGenerator) {
        
        super.init(mapView: mapView, clusterIconGenerator: iconGenerator)
    }
    
    
    func markerWithPosition(position: CLLocationCoordinate2D, from: CLLocationCoordinate2D, userData: AnyObject, clusterIcon: UIImage, animated: Bool) -> GMSMarker {
        let initialPosition = animated ? from : position
        let marker = GMSMarker(position: initialPosition)
        marker.userData! = userData
        if clusterIcon.cgImage != nil {
            marker.icon = clusterIcon
        }
        else {
            marker.icon = self.getCustomTitleItem(userData: userData)
            
        }
        marker.map = mapView
        if animated
        {
            CATransaction.begin()
            CAAnimation.init().duration = kGMUAnimationDuration
            marker.layer.latitude = position.latitude
            marker.layer.longitude = position.longitude
            CATransaction.commit()
        }
        return marker
    }
    
    override func shouldRender(as cluster: GMUCluster, atZoom zoom: Float) -> Bool {
        return cluster.count >= 2 && zoom <= 20
    }
    
    func getCustomTitleItem(userData: AnyObject) -> UIImage {
        let item = userData as! MapMarker
        return item.marker.icon!
    }
}
