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

class MapViewDelegate: NSObject, MKMapViewDelegate, GMSMapViewDelegate {
    
    static let theMapViewDelegate = MapViewDelegate()

    weak var theMapView: MKMapView!
    weak var googleMapView: GMSMapView!
    weak var myLocation: CLLocation! = LocationManager.theLocationManager.getLocation()
    
    func setHomeVCMapRegion(){
        
        let span = MKCoordinateSpanMake(0.045, 0.045)
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
    
    
    

    
    
    
    //GMS Delegate methods
    
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        var listingToPresent: Listing!
        
        //NOT THE BEST WAY TO PRESENT THE LISTING
        for listing in DummyData.theDummyData.homesForSale {
            if ((listing.coordinate.latitude == marker.position.latitude) && (listing.coordinate.longitude == marker.position.longitude)){
                listingToPresent = listing
            }
        }
        
        let listingViewController = ListingDetailViewController()
        listingViewController.currentListing = listingToPresent as! HomeSale
        
        topController().navigationController?.pushViewController(listingViewController, animated: true)
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool{
//        
//        return true
//    }
    
    /* set a custom Info Window */
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
//        view.backgroundColor = UIColor.white
//        view.layer.cornerRadius = 6
//
//        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
//        lbl1.text = "Hi there!"
//        view.addSubview(lbl1)
//
//        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
//        lbl2.text = "I am a custom info window."
//        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        view.addSubview(lbl2)
//
//        return view
//    }
    
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
