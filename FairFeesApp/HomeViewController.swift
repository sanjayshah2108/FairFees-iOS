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
    var filterButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    var filterView: UIView!
    var filterViewIsInFront: Bool!
    var filterViewHeight: CGFloat!
    
    var priceFilterSlider: UISlider!
    var noOfBedroomsLabel: UILabel!
    var noOfBedroomsSegmentedControl: UISegmentedControl!
    var noOfBathroomsLabel: UILabel!
    var noOfBathroomsSegmentedControl: UISegmentedControl!
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
        guestUser = true
        locationManager = LocationManager.theLocationManager
        
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        searchBarHeight = 0
        filterViewHeight = 160
        
        setupDummyData()

        
        setupMapListSegmentTitle()
        setupTopRightButton()
        setupTopLeftButtons()
        
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
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
        //self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        //self.navigationController?.navigationBar.shadowImage = nil
        
        //self.navigationController?.navigationBar.isTranslucent = false
        homeTableView.reloadData()
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
            marker.map = homeMapView
        }
        
        view.addSubview(homeMapView)
        homeMapView.translatesAutoresizingMaskIntoConstraints = false
        
        ///Apple Maps stuff
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
    
    func setupTopLeftButtons(){
        topLeftButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        //self.navigationItem.leftBarButtonItem = topLeftButton
        
        filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(showHideFilterView))
        
        self.navigationItem.leftBarButtonItems = [topLeftButton, filterButton]
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
        
        if(filterViewIsInFront){
            view.bringSubview(toFront: filterView)
        }
    }
    
    @objc func newPostAction(){
        
        if(guestUser == true){
            
            let postAsGuestAlert = UIAlertController(title: "Sorry", message: "You need an account to make a post", preferredStyle: .alert)
            let createAccountAction = UIAlertAction(title: "Log in", style: .default, handler: { (alert: UIAlertAction!) in
                
                let loginViewController = LoginViewController()
                self.present(loginViewController, animated: true, completion: nil)
                
                loggedInBool = false
            })
            let cancelAction = UIAlertAction(title: "Just browse", style: .cancel, handler: nil)
            
            postAsGuestAlert.addAction(createAccountAction)
            postAsGuestAlert.addAction(cancelAction)
            
            self.present(postAsGuestAlert, animated: true, completion: nil)
        }
            
        else {
            let postViewController = PostViewController()
            self.navigationController?.pushViewController(postViewController, animated: true)
        }
    }
    
    @objc func showSearchBar(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.delegate = self
        searchController?.searchBar.frame = (CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
        view.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.setShowsCancelButton(true, animated: true)
        searchController?.searchBar.placeholder = "Search Address, Zip or City"
        searchController?.searchBar.isHidden = false
        searchController?.searchBar.becomeFirstResponder()
    
        definesPresentationContext = false
        
        // Keep the navigation bar visible.
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.modalPresentationStyle = .popover
    }
    
    //NOT BEING USED
    func setupSearchBar(){
        
        searchBar = UISearchBar()
        searchBar.frame = CGRect.zero
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search Address, Zip or City"
        view.addSubview(searchBar)
        searchBar.isHidden = true
        view.bringSubview(toFront: searchBar)
    }
    
     func setupFilterView(){
        filterView = UIView()
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
        
        noOfBathroomsLabel = UILabel()
        noOfBathroomsLabel.text = "No. of Bathrooms"
        noOfBathroomsLabel.font = UIFont(name: "GillSans-Light", size: 10)
        noOfBathroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(noOfBathroomsLabel)
        
        noOfBathroomsSegmentedControl = UISegmentedControl()
        noOfBathroomsSegmentedControl.frame = CGRect.zero
        noOfBathroomsSegmentedControl.insertSegment(withTitle: "1+", at: 0, animated: false)
        noOfBathroomsSegmentedControl.insertSegment(withTitle: "2+", at: 1, animated: false)
        noOfBathroomsSegmentedControl.insertSegment(withTitle: "3+", at: 2, animated: false)
        noOfBathroomsSegmentedControl.insertSegment(withTitle: "4+", at: 3, animated: false)
        noOfBathroomsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(noOfBathroomsSegmentedControl)
        
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
        
        filterViewIsInFront = false
    }
    
    @objc func showHideFilterView(){
        
        if(!filterViewIsInFront){
            
            UIView.animate(withDuration: 0, animations: {
                
    
            }, completion: { (finished: Bool) in
                self.filterView.frame.size.height = self.filterViewHeight
                self.filterView.isHidden = false
            })
            
            view.bringSubview(toFront: filterView)
            filterViewIsInFront = true
            view.layoutIfNeeded()
            
            swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
            swipeUpGesture.direction = .up
            filterView.addGestureRecognizer(swipeUpGesture)
            }
        
        else if (filterViewIsInFront){
            UIView.animate(withDuration: 0, animations: {
                
                
            }, completion: { (finished: Bool) in
                self.filterView.frame.size.height = 0
                self.filterView.isHidden = true
            })
            
            filterViewIsInFront = false
            view.layoutIfNeeded()
        }
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
        NSLayoutConstraint(item: filterView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: filterViewHeight).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        
        //priceFilterSlider
        NSLayoutConstraint(item: priceFilterSlider, attribute: .top, relatedBy: .equal, toItem: filterView, attribute: .top , multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsLabel, attribute: .top , multiplier: 1, constant: -15).isActive = true
        
        //bedroomNumberLabel
        //NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .top, relatedBy: .equal, toItem: priceFilterSlider, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsSegmentedControl, attribute: .top , multiplier: 1, constant: -5).isActive = true
        
        //bedroomNumberSegment
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: noOfBathroomsLabel, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //bathroomNumberLabel
        //NSLayoutConstraint(item: noOfBathroomsLabel, attribute: .top, relatedBy: .equal, toItem: priceFilterSlider, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noOfBathroomsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBathroomsLabel, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBathroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBathroomsSegmentedControl, attribute: .top , multiplier: 1, constant: -5).isActive = true
        
        //bathroomNumberSegment
        NSLayoutConstraint(item: noOfBathroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: noOfBathroomsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBathroomsSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: noOfBathroomsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: applyFilterButton, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
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
        
        //cell.leftImageView.image = listing.photos[0]
        cell.leftImageView.contentMode = .scaleToFill
        cell.nameLabel.text = listing.name
        cell.sizeLabel.text = "\(listing.size!) SF"
        cell.priceLabel.text = "$\(listing.price!)"
        cell.addressLabel.text = listing.address
        cell.bedroomsLabel.text = "\(listing.bedroomNumber!) br"
        cell.bathroomsLabel.text = "\(listing.bathroomNumber!) ba"
        
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
    
    //gestureHandlers
    @objc func handleSwipeGestures(swipeGesture: UISwipeGestureRecognizer){
        
        if(swipeGesture.direction == .up){
            filterView.removeGestureRecognizer(swipeUpGesture)
            self.showHideFilterView()
        }
    }
    
    //searchBarDelegateMethods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
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
        searchController?.searchBar.isHidden = true
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
    
    
        
    // Handle the user's selection in place search.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
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
        let cameraUpdate = GMSCameraUpdate.setTarget(place.coordinate, zoom: 10.0)
        
        homeMapView.moveCamera(cameraUpdate)
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

