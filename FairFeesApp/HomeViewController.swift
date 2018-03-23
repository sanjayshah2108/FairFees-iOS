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
import FirebaseStorage
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UISearchBarDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    let myDownloadCompleteNotificationKey = "myDownloadCompleteNotificationKey"
    
    var locationManager: CLLocationManager!
    
    //var homeMapView: MKMapView!
    var homeMapView: GMSMapView!
    var homeTableView: UITableView!
    var mapListSegmentedControl: UISegmentedControl!
    var topRightButton: UIBarButtonItem!
    var topLeftButton: UIBarButtonItem!
    var filterButton: UIBarButtonItem!
    var profileButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    var filterView: UIView!
    var filterViewIsInFront: Bool!
    var filterViewHeight: CGFloat!
    
    var buyRentSegmentedControl: UISegmentedControl!
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

    var listingsToPresent: [Listing]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guestUser = true
        locationManager = LocationManager.theLocationManager
    
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        searchBarHeight = 0
        filterViewHeight = 190
        
        setupMapListSegmentTitle()
        setupTopRightButtons()
        setupTopLeftButtons()
        
        listingsToPresent = []
        
        setupHomeMapView()
        setupHomeTableView()
        setupSearchBar()
        setupFilterView()
        
        setupConstraints()
        
        //right now we are only being notifide when rentals are downloaded, because they are being dowloaded last
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMapAndTable), name: NSNotification.Name(rawValue: "rentalHomesDownloadCompleteNotificationKey"), object: nil)
        
        //setupDummyData()
        ReadFirebaseData.readUsers()
        ReadFirebaseData.readHomesForSale()
        ReadFirebaseData.readHomesForRent()
        
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
    
    func setListingsToPresent(){
        
        if (buyRentSegmentedControl.selectedSegmentIndex == 0){
            listingsToPresent = FirebaseData.sharedInstance.homesForSale
        }
        else if (buyRentSegmentedControl.selectedSegmentIndex == 1){
            listingsToPresent = FirebaseData.sharedInstance.homesForRent
        }
        else {
        //homesForSale will be default
        listingsToPresent = FirebaseData.sharedInstance.homesForSale
        }
    }
    
    @objc func reloadMapAndTable(){
        
        homeMapView.clear()
        setListingsToPresent()
        
        for listing in listingsToPresent{
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: listing.coordinate.latitude, longitude: listing.coordinate.longitude)
                        marker.map = homeMapView
                    }
        
        homeTableView.reloadData()
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
        
        
        
//        for listing in DummyData.theDummyData.homesForSale{
//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: listing.coordinate.latitude, longitude: listing.coordinate.longitude)
//            marker.map = homeMapView
//        }
        
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
    
    func setupTopRightButtons(){
        topRightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPostAction))
        profileButton =  UIBarButtonItem(title: "Prof", style: .plain, target: self, action: #selector(profileViewControllerSegue))
        
        self.navigationItem.rightBarButtonItems = [profileButton, topRightButton]
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
    
    @objc func profileViewControllerSegue(){
        
        if(guestUser == true){
            signInAlert(title: "You need to sign in to see your profile")
        }
        else {
            let profileViewController = ProfileViewController()
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    @objc func newPostAction(){
        
        if(guestUser == true){
            signInAlert(title: "You need to sign in to make a post")
        }
        else {
            let postViewController = PostViewController()
            self.navigationController?.pushViewController(postViewController, animated: true)
        }
    }
    
    func signInAlert(title: String){
        let signInAlert = UIAlertController(title: "Sorry", message: title, preferredStyle: .alert)
        let createAccountAction = UIAlertAction(title: "Log in", style: .default, handler: { (alert: UIAlertAction!) in
            
            let loginViewController = LoginViewController()
            self.present(loginViewController, animated: true, completion: nil)
            
            loggedInBool = false
        })
        let cancelAction = UIAlertAction(title: "Just browse", style: .cancel, handler: nil)
        
        signInAlert.addAction(createAccountAction)
        signInAlert.addAction(cancelAction)
        
        self.present(signInAlert, animated: true, completion: nil)
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
        
        buyRentSegmentedControl = UISegmentedControl()
        buyRentSegmentedControl.insertSegment(withTitle: "Buy", at: 0, animated: false)
        buyRentSegmentedControl.insertSegment(withTitle: "Rent", at: 1, animated: false)
        buyRentSegmentedControl.selectedSegmentIndex = 0
        buyRentSegmentedControl.addTarget(self, action: #selector(reloadMapAndTable), for: .valueChanged)
        buyRentSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(buyRentSegmentedControl)
        
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
    
    @objc func showListingsForSaleOrForRent(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            listingsToPresent = FirebaseData.sharedInstance.homesForSale
        }
        
        else if sender.selectedSegmentIndex == 1 {
            listingsToPresent = FirebaseData.sharedInstance.homesForRent
        }
        homeMapView.clear()
        homeTableView.reloadData()
    
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
        
        //buyRentSegmentedControl
        NSLayoutConstraint(item: buyRentSegmentedControl, attribute: .top, relatedBy: .equal, toItem: filterView, attribute: .top , multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: buyRentSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: buyRentSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: buyRentSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        
        //priceFilterSlider
        NSLayoutConstraint(item: priceFilterSlider, attribute: .top, relatedBy: .equal, toItem: buyRentSegmentedControl, attribute: .bottom , multiplier: 1, constant: 15).isActive = true
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
        return listingsToPresent.count
        //return DummyData.theDummyData.homesForSale.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storageRef = Storage.storage().reference()
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell") as! HomeTableViewCell
        
        let listing =  listingsToPresent[indexPath.row]
        
        if (buyRentSegmentedControl.selectedSegmentIndex == 0){
            let homeSale = listing as! HomeSale
            
            cell.bedroomsLabel.text = "\(homeSale.bedroomNumber!) br"
            cell.bathroomsLabel.text = "\(homeSale.bathroomNumber!) ba"
            cell.priceLabel.text = "$\(homeSale.price!)"
        }
        else if (buyRentSegmentedControl.selectedSegmentIndex == 1){
            let homeRental = listingsToPresent[indexPath.row] as! HomeRental
            
            cell.bedroomsLabel.text = "\(homeRental.bedroomNumber!) br"
            cell.bathroomsLabel.text = "\(homeRental.bathroomNumber!) ba"
            cell.priceLabel.text = "$\(homeRental.monthlyRent!)/month"
            
        }
        
        cell.leftImageView.sd_setImage(with: storageRef.child(listing.photoRefs[0]), placeholderImage: nil)
        cell.leftImageView.contentMode = .scaleToFill
        cell.nameLabel.text = listing.name
        cell.sizeLabel.text = "\(listing.size!) SF"
        cell.addressLabel.text = listing.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listingViewController = ListingDetailViewController()
        
        //listingViewController.currentListing = DummyData.theDummyData.homesForSale[indexPath.row]
        
        if (buyRentSegmentedControl.selectedSegmentIndex == 0){
             listingViewController.currentListing = listingsToPresent![indexPath.row] as! HomeSale
        }
        else if (buyRentSegmentedControl.selectedSegmentIndex == 1){
            listingViewController.currentListing = listingsToPresent![indexPath.row] as! HomeRental
        }
        
        
        
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

