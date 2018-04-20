//
//  CompareListingsViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-17.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class CompareListingsViewController: UIViewController, GMSMapViewDelegate {
    
    var listingsArray: [Listing]!
    weak var leftListing: Listing!
    weak var rightListing: Listing!
    
    var leftListingContainerView: UIView!
    var leftListingCompareTableViewController: CompareListingsTableViewController!
    var rightListingContainerView: UIView!
    var rightListingCompareTableViewController: CompareListingsTableViewController!
    
    var mapView: GMSMapView!
    var polylinesToShow: [GMSPolyline]!
    var leftPolyline: GMSPolyline!
    var leftDistanceLabel: UILabel!
    var leftMarker: GMSMarker!
    var rightPolyline: GMSPolyline!
    var rightDistanceLabel: UILabel!
    var rightMarker: GMSMarker!
    
    //left TableView is 0
    //right TableView is 1
    var tableViewIDLastSelected: Int!

    var bottomToolbar: UIToolbar!
    var exploreButton: UIBarButtonItem!
    var compareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        listingsArray = []

        setupChildViewControllers()
        setupMapView()
        setupBottomToolbar()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = UIColor.white
        view.addSubview(statusBarView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue:"compareStackDownloadedKey"), object: nil)
        
        ReadFirebaseData.readCurrentUser(user: FirebaseData.sharedInstance.currentUser!)
      
        setupConstraints()
    }
    
    @objc func reloadTableView(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:"compareStackDownloadedKey"), object: nil)
        
        listingsArray = FirebaseData.sharedInstance.currentUser?.compareStackListings
        
        leftListingCompareTableViewController.listingsArray = listingsArray
        leftListingCompareTableViewController.tableView.reloadData()
        
        rightListingCompareTableViewController.listingsArray = listingsArray
        rightListingCompareTableViewController.tableView.reloadData()
    }
    
    func setupChildViewControllers(){
        
        leftListingContainerView = UIView()
        leftListingContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftListingContainerView)
        
        rightListingContainerView = UIView()
        rightListingContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightListingContainerView)
        
        leftListingCompareTableViewController = CompareListingsTableViewController()
        leftListingCompareTableViewController.tableViewID = 0
        leftListingCompareTableViewController.listingsArray = listingsArray
        addChildViewController(leftListingCompareTableViewController)
        leftListingContainerView.addSubview(leftListingCompareTableViewController.view)
        leftListingCompareTableViewController.view.frame = leftListingContainerView.bounds
        leftListingCompareTableViewController.didMove(toParentViewController: self)
        
        rightListingCompareTableViewController = CompareListingsTableViewController()
        rightListingCompareTableViewController.tableViewID = 1
        rightListingCompareTableViewController.listingsArray = listingsArray
        addChildViewController(rightListingCompareTableViewController)
        rightListingContainerView.addSubview(rightListingCompareTableViewController.view)
        rightListingCompareTableViewController.view.frame = rightListingContainerView.bounds
        rightListingCompareTableViewController.didMove(toParentViewController: self)
        
    }
    
    func setupMapView(){
        
        polylinesToShow = []
        
        let camera = GMSCameraPosition.camera(withLatitude: LocationManager.theLocationManager.getLocation().coordinate.latitude, longitude: LocationManager.theLocationManager.getLocation().coordinate.longitude, zoom: 12.0)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = MapViewDelegate.theMapViewDelegate
        MapViewDelegate.theMapViewDelegate.googleMapView = mapView
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        leftDistanceLabel = UILabel()
        leftDistanceLabel.backgroundColor = UIColor.white
        leftDistanceLabel.layer.cornerRadius = 10
        leftDistanceLabel.textAlignment = .center
        leftDistanceLabel.isHidden = true
        leftDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(leftDistanceLabel)
        
        rightDistanceLabel = UILabel()
        rightDistanceLabel.backgroundColor = UIColor.white
        rightDistanceLabel.layer.cornerRadius = 10
        rightDistanceLabel.textAlignment = .center
        rightDistanceLabel.isHidden = true
        rightDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(rightDistanceLabel)
        
    }
    
    func setupBottomToolbar(){
        
        bottomToolbar = UIToolbar()
        bottomToolbar.backgroundColor = UIColor.white
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomToolbar)
        
        exploreButton = UIBarButtonItem(title: "Explore", style: .plain, target: self, action: #selector(goToExploreNavigationController))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        compareButton = UIBarButtonItem(title: "Compare", style: .plain, target: self, action: #selector(goToCompareViewController))
        compareButton.tintColor = UIColor.gray
        
        bottomToolbar.items = [exploreButton, flexibleSpace, compareButton]
    }
    
    @objc func goToExploreNavigationController(){
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func goToCompareViewController(){
    
        print("THIS COMPARE BUTTON SHOULD BE DISABLED")
    }

    func setupConstraints(){
        
        //leftListingView
        NSLayoutConstraint(item: leftListingContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftListingContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftListingContainerView, attribute: .trailing, relatedBy: .equal, toItem: rightListingContainerView, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftListingContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY , multiplier: 1, constant: 0).isActive = true
        
        //rightListingView
        NSLayoutConstraint(item: rightListingContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: rightListingContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: rightListingContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: rightListingContainerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width , multiplier: 0.5, constant: 0).isActive = true
        
    
        //mapView
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: bottomToolbar, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        //leftDistanceLabel
        NSLayoutConstraint(item: leftDistanceLabel, attribute: .leading, relatedBy: .equal, toItem: mapView, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: leftDistanceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: leftDistanceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: leftDistanceLabel, attribute: .bottom, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
        //rightDistanceLabel
        NSLayoutConstraint(item: rightDistanceLabel, attribute: .leading, relatedBy: .equal, toItem: mapView, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: rightDistanceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: rightDistanceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: rightDistanceLabel, attribute: .bottom, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
        
        //bottomToolbar
        NSLayoutConstraint(item: bottomToolbar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bottomToolbar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bottomToolbar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bottomToolbar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 30).isActive = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func addOverlaysToMap(tableViewID: Int, listing: Listing){
        
        tableViewIDLastSelected = tableViewID
        
        DirectionsManager.theDirectionsManager.mapView = mapView
        
        //since one or both of the tableViews might not have been selected yet, we need to check, and set the activePolylines
        if (leftPolyline != nil) && (rightPolyline != nil){
            DirectionsManager.theDirectionsManager.activePolylines = [leftPolyline, rightPolyline]
        }
            
        else if(leftPolyline != nil){
            DirectionsManager.theDirectionsManager.activePolylines = [leftPolyline]
        }
        else if (rightPolyline != nil){
            DirectionsManager.theDirectionsManager.activePolylines = [rightPolyline]
        }
        else {
            DirectionsManager.theDirectionsManager.activePolylines = []
        }
        
        //if the left table was clicked on
        if (tableViewIDLastSelected == 0){
            
            //remove the old leftPolyline if there was one
            if (leftPolyline != nil) {
                leftPolyline.map = nil
            }
            
            //set the new marker position
            if (leftMarker == nil){
                leftMarker = GMSMarker()
                leftMarker.map = mapView
            }
            leftMarker.position = CLLocationCoordinate2D(latitude: listing.coordinate.latitude, longitude: listing.coordinate.longitude)
            
            //update the leftDistanceLabel
            DirectionsManager.theDirectionsManager.distanceLabel = leftDistanceLabel
            
        }
            
        //if the right table was clicked on, remove the old rightPolyline
        else if (tableViewIDLastSelected == 1){
            
            //remove the old rightPolyline if there was one
            if (rightPolyline != nil) {
                rightPolyline.map = nil
            }
            
            //set the new marker position
            if(rightMarker == nil){
                rightMarker = GMSMarker()
                rightMarker.map = mapView
            }
            rightMarker.position = CLLocationCoordinate2D(latitude: listing.coordinate.latitude, longitude: listing.coordinate.longitude)
            
            //update the rightDistanceLabel
            DirectionsManager.theDirectionsManager.distanceLabel = rightDistanceLabel
        }
        
        //and finally add the new polyline
        DirectionsManager.theDirectionsManager.getPolylineRoute(from: LocationManager.theLocationManager.currentLocation, to: listing.location)
        
        //We need to keep track of the left and right polylines, and since they take some time to added, we use a notification
        NotificationCenter.default.addObserver(self, selector: #selector(assignPolylines), name: NSNotification.Name(rawValue: "polylineAddedKey"), object: nil)
    }
    
    @objc func assignPolylines(){
        
        if (tableViewIDLastSelected == 0){
            leftPolyline = DirectionsManager.theDirectionsManager.polylineToShow
        }
            
        else if (tableViewIDLastSelected == 1){
            rightPolyline = DirectionsManager.theDirectionsManager.polylineToShow
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "polylineAddedKey"), object: nil)
    }
}
