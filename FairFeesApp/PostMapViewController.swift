//
//  PostMapViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-08.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import GooglePlacePicker

class PostMapViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, MKLocalSearchCompleterDelegate  {
    

    

    var previousVC: PostViewController!
    
    var searchController: UISearchController!
   
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var searchCompleter: MKLocalSearchCompleter!
    var searchResultsTableViewController: PostMapSearchResultsTableViewController!

    //var annotation:MKAnnotation!
    var pointAnnotation:MKPointAnnotation!
    var markerAnnotationView:MKMarkerAnnotationView!
    var selectedAnnotation: MKPointAnnotation!
    
    var city: String!
    var country: String!
    var province: String!
    var zipcode: String!
    var address: String!

    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var saveButton: UIButton!
    var myLocationButton: UIButton!
    
    var postMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select Location"
        definesPresentationContext = true
        
        setupMapView()
        setupSearchFunctionality()
        setupButtons()
        setupConstraints()
        
        let thisViewControllerIndex = self.navigationController?.viewControllers.index(of: self)
        previousVC = self.navigationController?.viewControllers[thisViewControllerIndex!-1] as! PostViewController
    }
    func setupMapView(){
        postMapView = MKMapView()
        postMapView.showsUserLocation = true
        view.addSubview(postMapView)
        postMapView.translatesAutoresizingMaskIntoConstraints = false
        
        postMapView.delegate = self
    
        let span = MKCoordinateSpanMake(0.045, 0.045)
        postMapView.setRegion(MKCoordinateRegionMake(LocationManager.theLocationManager.currentLocation.coordinate, span) , animated: true)
        
        postMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "postLocationMarkerView")
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedALocation(sender:)))
        postMapView.addGestureRecognizer(tapGestureRecognizer)
        
        selectedAnnotation = MKPointAnnotation()
    }
    
    
    func setupSearchFunctionality(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(searchButtonClicked))
      
        searchResultsTableViewController = PostMapSearchResultsTableViewController()
        
        //searchCompleter delegate stuff
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.region = self.postMapView.region
        searchCompleter.filterType = MKSearchCompletionFilterType.locationsAndQueries
    }
    
    func setupButtons(){
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = UIProperties.sharedUIProperties.primaryRedColor
        saveButton.layer.backgroundColor =  UIProperties.sharedUIProperties.primaryBlackColor.cgColor
        saveButton.addTarget(self, action: #selector(saveLocationButon), for: .touchUpInside)
        saveButton.layer.cornerRadius = 8
        saveButton.layer.masksToBounds = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        view.bringSubview(toFront: saveButton)
        
        myLocationButton = UIButton()
        myLocationButton.setTitle("My", for: .normal)
        myLocationButton.tintColor = UIProperties.sharedUIProperties.primaryRedColor
        myLocationButton.layer.backgroundColor = UIProperties.sharedUIProperties.primaryBlackColor.cgColor
        myLocationButton.addTarget(self, action: #selector(useMyLocationButton), for: .touchUpInside)
        myLocationButton.layer.cornerRadius = 8
        myLocationButton.layer.masksToBounds = false
        myLocationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myLocationButton)
        view.bringSubview(toFront: myLocationButton)
    
    }
    func setupConstraints(){
        //postMapView
        NSLayoutConstraint(item: postMapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: postMapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: postMapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: postMapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        //saveButton
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -60).isActive = true
        
        //myLocationButton
        NSLayoutConstraint(item: myLocationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: myLocationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: myLocationButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: myLocationButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -60).isActive = true
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.searchCompleter.region = self.postMapView.region
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchButtonClicked () {
        
        searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchCompleter.queryFragment = self.searchController.searchBar.text!
        searchResultsTableViewController.tableView.reloadData()
    }
    
    //search-completer delegate methods
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResultsTableViewController.searchResults = completer.results
        searchResultsTableViewController.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //handleError
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        searchResultsTableViewController.placeToSearch = searchBar.text!
        locationPlotter()
    }
    
    func locationPlotter(){
        
        //remove existing annotation
        if (self.pointAnnotation != nil) {
            self.postMapView.removeAnnotation(pointAnnotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchResultsTableViewController.placeToSearch
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.searchResultsTableViewController.placeToSearch
            
            self.reverseGeocode(location: CLLocation(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude))
        
            
            self.postMapView.addAnnotation(self.pointAnnotation)
            
            // self.pointAnnotation = localSearchResponse?.mapItems[0].placemark.thoroughfare
            
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            self.markerAnnotationView = MKMarkerAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.markerAnnotationView.markerTintColor = UIProperties.sharedUIProperties.primaryRedColor
            
            
            self.postMapView.centerCoordinate = self.pointAnnotation.coordinate
            self.postMapView.addAnnotation(self.markerAnnotationView.annotation!)
        }
    }
    
    
    @objc func saveLocationButon(_ sender: UIButton) {
        
        if (self.pointAnnotation != nil){
            self.navigationController?.popViewController(animated: true)
           // previousVC.addressTextField.text = self.pointAnnotation.title ?? ""
            previousVC.addressTextField.text = self.address ?? ""
            previousVC.cityTextField.text = self.city ?? ""
            previousVC.provinceTextField.text = self.province ?? ""
            previousVC.countryTextField.text = self.country ?? ""
            previousVC.zipcodeTextField.text = self.zipcode ?? ""
            previousVC.location = CLLocation(latitude: self.pointAnnotation.coordinate.latitude, longitude: self.pointAnnotation.coordinate.longitude)
            
        }
        else {
            
            let noLocationAlert = UIAlertController(title: "Can't Save!", message: "Select a location before saving", preferredStyle: UIAlertControllerStyle.alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil)
            
            noLocationAlert.addAction(okayAction)
            present(noLocationAlert, animated: true, completion: nil)
        }
    }
    
    
    @objc func tappedALocation(sender: UITapGestureRecognizer) {
        
        let touchLocation = sender.location(in: postMapView)
        let locationCoordinate = postMapView.convert(touchLocation, toCoordinateFrom: postMapView)
        
        if (self.pointAnnotation != nil) {
            self.postMapView.removeAnnotation(self.pointAnnotation)
        }
        
        pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = locationCoordinate
        
        reverseGeocode(location: CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude))
    }
    
    
    @objc func useMyLocationButton(_ sender: UIButton) {
        
        reverseGeocode(location: LocationManager.theLocationManager.getLocation())
    
    }
    
    func reverseGeocode(location: CLLocation){
    
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks!.count > 0) {
                let pm = placemarks![0]
                
                if(pm.thoroughfare != nil && pm.subThoroughfare != nil){
                    // not all places have thoroughfare & subThoroughfare so validate those values
                    self.pointAnnotation.title = pm.subThoroughfare! + ", " + pm.thoroughfare!
                    self.pointAnnotation.subtitle = pm.subLocality
                    self.address = pm.subThoroughfare! + "" + pm.thoroughfare!
                    self.city = pm.locality
                    self.province = pm.administrativeArea
                    self.country = pm.country
                    self.zipcode = pm.postalCode
                    self.postMapView.addAnnotation(self.pointAnnotation)
                    
                }
                else if(pm.subThoroughfare != nil) {
                    self.pointAnnotation.title = pm.thoroughfare!
                    self.pointAnnotation.subtitle = pm.subLocality
                    self.address = pm.thoroughfare!
                    self.city = pm.locality
                    self.province = pm.administrativeArea
                    self.country = pm.country
                    self.zipcode = pm.postalCode
                    self.postMapView.addAnnotation(self.pointAnnotation)
                }
                    
                else {
                    self.pointAnnotation.title = "Unknown Place"
                    self.postMapView.addAnnotation(self.pointAnnotation)
                    print("Problem with the data received from geocoder")
                    
                }
            }
            else {
                self.pointAnnotation.title = "Unknown Place"
                self.postMapView.addAnnotation(self.pointAnnotation)
                print("Problem with the data received from geocoder")
            }
        })
        
    }
}
