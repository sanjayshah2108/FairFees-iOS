//
//  MapViewDelegate.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Firebase

class MapViewDelegate: NSObject, MKMapViewDelegate, GMSMapViewDelegate, GMUClusterManagerDelegate {
    
    static let theMapViewDelegate = MapViewDelegate()
    
    weak var googleMapView: GMSMapView!
    var clusterManager: GMUClusterManager!
    weak var myLocation: CLLocation! = LocationManager.theLocationManager.getLocation()
    weak var selectedMarker: GMSMarker!
    let storageRef = Storage.storage().reference()
    

    //GMS Delegate methods
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return nil
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool{
        
        let update = GMSCameraUpdate.setTarget(marker.position, zoom: 15.0)
        self.googleMapView.animate(with: update)
        
        selectedMarker = marker
        marker.iconView?.subviews[0].backgroundColor = UIColor.blue
        
        let homeVC = topController() as! HomeViewController
        homeVC.presentListingPreview(marker: marker)
        
        return true
    }
    

 

    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    
    //clustermarkers
    
    func setupClusterManager(){
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = CustomGMUClusterRenderer(mapView: googleMapView, clusterIconGenerator: iconGenerator)
        
        clusterManager = GMUClusterManager(map: googleMapView, algorithm: algorithm, renderer: renderer)
    
        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        //clusterManager.cluster()
        
        clusterManager.setDelegate(self, mapDelegate: self)

    }
    
  
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: googleMapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        googleMapView.moveCamera(update)
        
        return true
    }
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        
        var marker = GMSMarker()
        if let model = object as? MapMarker {
            // set image view for gmsmarker
            marker = model.marker
        }
        
        return marker
    }

    
    
    //find out which VC is using this
    func topController(_ parent:UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return topController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return topController(top)
            } else if let presented = vc.presentedViewController {
                return topController(presented)
            } else {
                return vc
            }
        } else {
            return topController(UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
}
