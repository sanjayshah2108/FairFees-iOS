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

class MapViewDelegate: NSObject, MKMapViewDelegate, GMSMapViewDelegate {
    
    static let theMapViewDelegate = MapViewDelegate()

    weak var theMapView: MKMapView!
    weak var googleMapView: GMSMapView!
    weak var myLocation: CLLocation! = LocationManager.theLocationManager.getLocation()
    weak var selectedMarker: GMSMarker!
    let storageRef = Storage.storage().reference()
    
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
        
        //var listingToPresent: Listing!
        var homeSaleToPresent: HomeSale!
        var homeRentalToPresent: HomeRental!
        
        let listingViewController = ListingDetailViewController()
        
        //NOT THE BEST WAY TO FIND THE LISTING
        for listing in FirebaseData.sharedInstance.homesForSale {
            if ((listing.coordinate.latitude == marker.position.latitude) && (listing.coordinate.longitude == marker.position.longitude)){
                homeSaleToPresent = listing
                listingViewController.currentListing = homeSaleToPresent
            }
        }
        
        for listing in FirebaseData.sharedInstance.homesForRent {
            if ((listing.coordinate.latitude == marker.position.latitude) && (listing.coordinate.longitude == marker.position.longitude)){
                homeRentalToPresent = listing
                listingViewController.currentListing = homeRentalToPresent
            }
        }
        
        topController().navigationController?.pushViewController(listingViewController, animated: true)
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool{
        
        let update = GMSCameraUpdate.setTarget(marker.position, zoom: 15.0)
        self.googleMapView.animate(with: update)
        
        selectedMarker = marker
        marker.iconView?.subviews[0].backgroundColor = UIColor.blue
        presentListingPreview(marker: marker)
        return true
    }
    
    
    func presentListingPreview(marker: GMSMarker){
        
        var listingToPresent: Listing!
        var homeSaleToPresent: HomeSale!
        var homeRentalToPresent: HomeRental!
        
        
        //NOT THE BEST WAY TO FIND THE LISTING
        for listing in FirebaseData.sharedInstance.homesForSale {
            if ((listing.coordinate.latitude == marker.position.latitude) && (listing.coordinate.longitude == marker.position.longitude)){
                homeSaleToPresent = listing
                listingToPresent = homeSaleToPresent
            }
        }
        
        for listing in FirebaseData.sharedInstance.homesForRent {
            if ((listing.coordinate.latitude == marker.position.latitude) && (listing.coordinate.longitude == marker.position.longitude)){
                homeRentalToPresent = listing
                listingToPresent = homeRentalToPresent
            }
        }
        
        let homeVC = topController() as! HomeViewController
        homeVC.showListingPreview(listing: listingToPresent)
        
    }

    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        var listingToPresent: Listing!
        var homeSaleToPresent: HomeSale!
        var homeRentalToPresent: HomeRental!
        
        
        //NOT THE BEST WAY TO FIND THE LISTING
        for listing in FirebaseData.sharedInstance.homesForSale {
            if ((listing.coordinate.latitude == marker.position.latitude) && (listing.coordinate.longitude == marker.position.longitude)){
                homeSaleToPresent = listing
                listingToPresent = homeSaleToPresent
                
            }
        }
        
        for listing in FirebaseData.sharedInstance.homesForRent {
            if ((listing.coordinate.latitude == marker.position.latitude) && (listing.coordinate.longitude == marker.position.longitude)){
                homeRentalToPresent = listing
                listingToPresent = homeRentalToPresent
            }
        }
        

        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 60))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let imageView =  UIImageView(frame: CGRect(x: 2, y: 2, width: view.frame.size.width/3, height: view.frame.size.height))
        imageView.sd_setImage(with: storageRef.child(listingToPresent.photoRefs[0]), placeholderImage: nil)
        //imageView.image = listingToPresent.photos[0]
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        let nameLabel = UILabel(frame: CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        nameLabel.text = listingToPresent.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

//        let addressLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y + nameLabel.frame.size.height + 14, width: view.frame.size.width - 16, height: 15))
//        addressLabel.text = listingToPresent.address
//        addressLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        addressLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(addressLabel)
        

        
        let priceLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y + nameLabel.frame.size.height + 14, width: view.frame.size.width - 16, height: 15))
        //priceLabel.text = listingToPresent.address
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)
        
        if(listingToPresent.isKind(of: HomeRental.self)){
            let currentHomeRental = listingToPresent as! HomeRental
           priceLabel.text = "$\((currentHomeRental.monthlyRent)!)/month"
        }
        else if (listingToPresent.isKind(of: HomeSale.self)){
            let currentHomeSale = listingToPresent as! HomeSale
            priceLabel.text = "$\((currentHomeSale.price)!)"
        }
        
//        let bedroomsLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y + nameLabel.frame.size.height + 14, width: view.frame.size.width - 16, height: 15))
//        bedroomsLabel.text = String(listingToPresent.bedroomNumber!) + "br"
//        bedroomsLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
//        bedroomsLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bedroomsLabel)
//        
//        let bathroomsLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y + nameLabel.frame.size.height + 14, width: view.frame.size.width - 16, height: 15))
//        bathroomsLabel.text = String(listingToPresent.bathroomNumber!) + "ba"
//        bathroomsLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
//        bathroomsLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bathroomsLabel)
//        
//        let sizeLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y + nameLabel.frame.size.height + 14, width: view.frame.size.width - 16, height: 15))
//        sizeLabel.text = String(listingToPresent.bathroomNumber!) + "SF"
//        sizeLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
//        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(sizeLabel)
        
        //imageView
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 65).isActive = true
        
        //nameLabel
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8).isActive = true
        //NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -7).isActive = true
        
        //priceLabel
        NSLayoutConstraint(item: priceLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -7).isActive = true
        
//        //addressLabel
//        NSLayoutConstraint(item: addressLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
//        //NSLayoutConstraint(item: addressLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -8).isActive = true
//        NSLayoutConstraint(item: addressLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: addressLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -7).isActive = true
        
//        //bedroomsLabel
//        NSLayoutConstraint(item: bedroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
//        NSLayoutConstraint(item: bedroomsLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -7).isActive = true
//
//        //bathroomsLabel
//        NSLayoutConstraint(item: bathroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
//        NSLayoutConstraint(item: bathroomsLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -7).isActive = true
//
//        //sizeLabel
//        NSLayoutConstraint(item: sizeLabel, attribute: .bottom, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
//        NSLayoutConstraint(item: sizeLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -7).isActive = true
        

        return view
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
