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
    
    func setHomeVCMapRegion(){
        
        let span = MKCoordinateSpanMake(0.009, 0.009)
        theMapView.setRegion(MKCoordinateRegionMake(myLocation.coordinate, span) , animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation){
            return nil
        }
        else if (annotation is Listing){
            
            return self.getMarkerFor(annotation: annotation, mapView: mapView)
        }
            
        else {
            return nil
        }
    }
    
    
    func getPostMarkerFor(annotation: MKAnnotation, mapView: MKMapView) -> MKAnnotationView? {
        
        
        let postLocationMarkerView = mapView.dequeueReusableAnnotationView(withIdentifier: "postLocationMarkerView", for: annotation) as! MKMarkerAnnotationView
        
        postLocationMarkerView.glyphTintColor = UIProperties.sharedUIProperties.primaryRedColor
        
        return postLocationMarkerView
    }
    

    
    func getMarkerFor(annotation: MKAnnotation, mapView: MKMapView) -> MKAnnotationView? {
        let listing = annotation as! Listing
        
        let newListingMarkerView = mapView.dequeueReusableAnnotationView(withIdentifier: "listingMarkerView", for: annotation) as! MKMarkerAnnotationView

        setMarkerPropertiesFor(newMarkerView: newListingMarkerView, listing: listing)
     
        return newListingMarkerView
    }
    
    func setMarkerPropertiesFor(newMarkerView: MKMarkerAnnotationView, listing: Listing){
        
        newMarkerView.markerTintColor = UIProperties.sharedUIProperties.primaryRedColor
        newMarkerView.glyphTintColor = UIProperties.sharedUIProperties.primaryGrayColor
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if (view.annotation is MKUserLocation){
            return
        }
        else {
            let listingToPresent = view.annotation as? Listing
            
            let listingViewController = ListingDetailViewController()
            listingViewController.currentListing = listingToPresent as! HomeSale
            
            topController().navigationController?.pushViewController(listingViewController, animated: true)
        }
    }
    
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
