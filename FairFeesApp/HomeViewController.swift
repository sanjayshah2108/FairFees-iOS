//
//  FirstViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import GooglePlaces


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UISearchBarDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, GMSAutocompleteResultsViewControllerDelegate {

    var locationManager: CLLocationManager!
    
    //var homeMapView: MKMapView!
    var homeMapView: GMSMapView!
    var homeTableView: UITableView!
    var mapListSegmentedControl: UISegmentedControl!
    var topRightButton: UIBarButtonItem!
    var topLeftButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    var filterView: UIView!
    
    var priceFilterSlider: UISlider!
    var noOfBedroomsLabel: UILabel!
    var noOfBedroomsSegmentedControl: UISegmentedControl!
    var applyFilterButton: UIButton!
    
    var navigationBarHeight: CGFloat!
    var searchBarHeight: CGFloat!
    
    var tapGesture: UITapGestureRecognizer!
    var swipeUpGesture: UISwipeGestureRecognizer!
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = LocationManager.theLocationManager
        
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        searchBarHeight = 0
        
        setupDummyData()
        
        setupMapListSegmentTitle()
        setupTopRightButton()
        setupTopLeftButton()
        setupHomeMapView()
        setupHomeTableView()
        setupSearchBar()
        setupFilterView()
        
        setupConstraints()
        
        view.bringSubview(toFront: homeMapView)
        view.bringSubview(toFront: searchBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //MapViewDelegate.theMapViewDelegate.theMapView = homeMapView
        
        homeTableView.reloadData()
        //homeMapView.removeAnnotations(homeMapView.annotations)
        //homeMapView.addAnnotations(DummyData.theDummyData.homesForSale)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDummyData(){
        
        DummyData.theDummyData.createUsers()
        DummyData.theDummyData.createListings()
    }
    
    
    func setupHomeMapView(){
        
        let camera = GMSCameraPosition.camera(withLatitude: LocationManager.theLocationManager.getLocation().coordinate.latitude, longitude: LocationManager.theLocationManager.getLocation().coordinate.longitude, zoom: 10.0)
        homeMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        homeMapView.delegate = MapViewDelegate.theMapViewDelegate
        MapViewDelegate.theMapViewDelegate.googleMapView = homeMapView
        homeMapView.settings.myLocationButton = true
        homeMapView.isMyLocationEnabled = true
        homeMapView.settings.compassButton = true
        homeMapView.settings.indoorPicker = true
        
        for listing in DummyData.theDummyData.homesForSale{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: listing.coordinate.latitude, longitude: listing.coordinate.longitude)
            marker.title = listing.name
            marker.snippet = listing.address
            marker.map = homeMapView
        }
        
        view.addSubview(homeMapView)
        homeMapView.translatesAutoresizingMaskIntoConstraints = false
        
//        homeMapView = MKMapView()
//        homeMapView.frame = CGRect.zero
//        homeMapView.delegate = MapViewDelegate.theMapViewDelegate
//        MapViewDelegate.theMapViewDelegate.theMapView = homeMapView
//        MapViewDelegate.theMapViewDelegate.setHomeVCMapRegion()
//        homeMapView.showsUserLocation = true
//
//        view.addSubview(homeMapView)
//        homeMapView.translatesAutoresizingMaskIntoConstraints = false
//
//        homeMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "listingMarkerView")
//
//        homeMapView.addAnnotations(DummyData.theDummyData.homesForSale)
    }
    
    func setupHomeTableView(){
        homeTableView = UITableView()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.frame = CGRect.zero
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewCell")
        
        view.addSubview(homeTableView)
        homeTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupMapListSegmentTitle(){
        mapListSegmentedControl = UISegmentedControl()
        mapListSegmentedControl.insertSegment(withTitle: "Map", at: 0, animated: false)
        mapListSegmentedControl.insertSegment(withTitle: "List", at: 2, animated: false)
        mapListSegmentedControl.selectedSegmentIndex = 0
        mapListSegmentedControl.addTarget(self, action: #selector(bringMapOrListToFront), for: .valueChanged)
        self.navigationItem.titleView = mapListSegmentedControl
    }
    
    func setupTopRightButton(){
        topRightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPostAction))
        self.navigationItem.rightBarButtonItem = topRightButton
    }
    
    func setupTopLeftButton(){
        topLeftButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        self.navigationItem.leftBarButtonItem = topLeftButton
    }
    
    @objc func bringMapOrListToFront(){
        switch mapListSegmentedControl.selectedSegmentIndex {
        case 0:
            view.bringSubview(toFront: homeMapView)
        case 1:
            view.bringSubview(toFront: homeTableView)
        default:
            print("SHOULDNT RUN")
        }
    }
    
    @objc func newPostAction(){
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    @objc func showSearchBar(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.delegate = self
        
        // Add the search bar to the right of the nav bar,
        // use a popover to display the results.
        // Set an explicit size as we don't want to use the entire nav bar.
        searchController?.searchBar.frame = (CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
        navigationItem.rightBarButtonItem = nil
//        navigationItem.leftBarButtonItem = nil
//        navigationItem.titleView = searchController?.searchBar
        view.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.setShowsCancelButton(true, animated: true)
        searchController?.searchBar.placeholder = "Search Address, Zip or City"
        searchController?.searchBar.becomeFirstResponder()
        
        searchBarHeight = 0
        searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.layoutIfNeeded()
        setupConstraints()
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Keep the navigation bar visible.
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.modalPresentationStyle = .popover
        
    }
    
    func setupSearchBar(){
        
        searchBar = UISearchBar()
        searchBar.frame = CGRect.zero
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search Address, Zip or City"
        view.addSubview(searchBar)
        view.bringSubview(toFront: searchBar)
    }
    
    func setupFilterView(){
        filterView = UIView(frame: CGRect(x: 0, y: navigationBarHeight + 40, width: view.frame.width, height: 200))
        filterView.backgroundColor = UIProperties.sharedUIProperties.primaryGrayColor
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        
        priceFilterSlider = UISlider()
        priceFilterSlider.maximumValue = 10000000
        priceFilterSlider.minimumValue = 100000
        priceFilterSlider.setValue(5000000, animated: true)
        priceFilterSlider.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(priceFilterSlider)
        
        noOfBedroomsLabel = UILabel()
        noOfBedroomsLabel.text = "No. of Bedrooms"
        noOfBedroomsLabel.font = UIFont(name: "GillSans-Light", size: 10)
        noOfBedroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(noOfBedroomsLabel)
        
        noOfBedroomsSegmentedControl = UISegmentedControl()
        noOfBedroomsSegmentedControl.frame = CGRect.zero
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "1+", at: 0, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "2+", at: 1, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "3+", at: 2, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "4+", at: 3, animated: false)
        noOfBedroomsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(noOfBedroomsSegmentedControl)
        
        applyFilterButton = UIButton()
        applyFilterButton.frame = CGRect.zero
        applyFilterButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        applyFilterButton.layer.cornerRadius = 5
        applyFilterButton.isEnabled = false
        applyFilterButton.setTitle("Apply Filters", for: .normal)
        applyFilterButton.isEnabled = true
        applyFilterButton.backgroundColor = UIColor.blue
        applyFilterButton.titleLabel?.textColor = UIProperties.sharedUIProperties.primaryBlackColor
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(applyFilterButton)
    }
    
    func setupConstraints(){
        
        //homeMapView
        NSLayoutConstraint(item: homeMapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeMapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeMapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeMapView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        
        
        //homeTableView
        NSLayoutConstraint(item: homeTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: navigationBarHeight).isActive = true
        
        //searchBar
        NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: searchBarHeight).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: navigationBarHeight).isActive = true
        
        //filterView
        NSLayoutConstraint(item: filterView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 120).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        
        //priceFilterSlider
        NSLayoutConstraint(item: priceFilterSlider, attribute: .top, relatedBy: .equal, toItem: filterView, attribute: .top , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsLabel, attribute: .top , multiplier: 1, constant: 0).isActive = true
        
        
        //bedroomNumberLabel
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .top, relatedBy: .equal, toItem: priceFilterSlider, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsSegmentedControl, attribute: .top , multiplier: 1, constant: -5).isActive = true
        
        //bedroomNumberSegment
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: applyFilterButton, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //applyFilterButton
        NSLayoutConstraint(item: applyFilterButton, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .bottom, relatedBy: .equal, toItem: filterView, attribute: .bottom , multiplier: 1, constant: -10).isActive = true
        
    }
    @objc func applyFilters(){
        print("apply filters")
    }
    
    
    //tableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DummyData.theDummyData.homesForSale.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell") as! HomeTableViewCell
        
        let listing = DummyData.theDummyData.homesForSale[indexPath.row]
        
        cell.leftImageView.image = listing.photos[0]
        cell.leftImageView.contentMode = .scaleToFill
        cell.nameLabel.text = listing.name
        cell.sizeLabel.text = "\(listing.size!) SF"
        cell.priceLabel.text = "$\(listing.price!)"
        cell.addressLabel.text = listing.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listingViewController = ListingDetailViewController()
        listingViewController.currentListing = DummyData.theDummyData.homesForSale[indexPath.row]
        
        self.navigationController?.pushViewController(listingViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    @objc func handleSwipeGestures(swipeGesture: UISwipeGestureRecognizer){
        
        if(swipeGesture.direction == .up){
            view.sendSubview(toBack: filterView)
            filterView.removeGestureRecognizer(swipeUpGesture)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        //view.bringSubview(toFront: filterView)
        //self.navigationController?.navigationBar.isHidden = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
        swipeUpGesture.direction = .up
        filterView.addGestureRecognizer(swipeUpGesture)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchBarHeight = 40
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        self.navigationItem.rightBarButtonItem = topRightButton
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.removeGestureRecognizer(tapGesture)
        //searchBarHeight = 40
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        self.navigationItem.rightBarButtonItem = topRightButton
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        //searchBarHeight = 40
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        self.navigationItem.rightBarButtonItem = topRightButton
    }
    
    
        
        // Handle the user's selection.
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            print("Place name: \(place.name)")
            print("Place address: \(place.formattedAddress)")
            print("Place attributions: \(place.attributions)")
            dismiss(animated: true, completion: nil)
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            // TODO: handle the error.
            print("Error: ", error.localizedDescription)
        }
        
        // User canceled the operation.
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            dismiss(animated: true, completion: nil)
        }
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    

}

