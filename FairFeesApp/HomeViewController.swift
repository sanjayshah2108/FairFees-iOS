
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
import WARangeSlider


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
    var loadMoreButton: UIButton!
    
    var navigationBarHeight: CGFloat!
    
    var tapGestureForTextFieldDelegate: UITapGestureRecognizer!
    var swipeUpGestureForFilterView: UISwipeGestureRecognizer!
    var tapGestureForListingPreview: UITapGestureRecognizer!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var chosenResultLocation: CLLocation!
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var numberOfListingsToShow: Int!
    var allOnlineListings: [Listing]!
    var listingsToPresent: [Listing]!
    var homeSalesToPresent: [HomeSale]!
    var homeRentalsToPresent: [HomeRental]!
    var typeOfListingsDisplayed: String!
    
    var listingPreview: UIView!
    var previewCancelButton : UIButton!
    var previewImageView: UIImageView!
    var previewPriceLabel: UILabel!
    var previewSizeLabel: UILabel!
    var previewBedroomsNoLabel: UILabel!
    var previewBathroomsNoLabel: UILabel!
    
    var bottomToolbar: UIToolbar!
    var exploreButton: UIBarButtonItem!
    var compareButton: UIBarButtonItem!
    
    var presentedListing: Listing!
    
   // public var listingsToCompare: [Listing]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guestUser = true
        locationManager = LocationManager.theLocationManager
        
        setupMapListSegmentTitle()
        setupTopRightButtons()
        setupTopLeftButtons()
        
        numberOfListingsToShow = 0
        allOnlineListings = []
        listingsToPresent = []
        homeSalesToPresent = []
        homeRentalsToPresent = []
        
       // listingsToCompare = []
        
        setupHomeMapView()
        setupHomeTableView()
        setupLoadMoreButton()
        setupBottomToolbar()
        //setupSearchBar()
        showSearchBar()

        setupConstraints()
        
        //right now we are only being notified when rentals are downloaded, because they are being dowloaded last
        NotificationCenter.default.addObserver(self, selector: #selector(setInitialListingsToPresent), name: NSNotification.Name(rawValue: "rentalHomesDownloadCompleteNotificationKey"), object: nil)
        
        //setupDummyData()
        
        //remove this
        ReadFirebaseData.readUsers()
        
        ReadFirebaseData.readHomesForSale()
        ReadFirebaseData.readHomesForRent()
        
        view.bringSubview(toFront: homeMapView)
        //view.bringSubview(toFront: searchBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        MapViewDelegate.theMapViewDelegate.googleMapView = homeMapView
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil

        homeTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // navigationItem.hidesSearchBarWhenScrolling = true
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
        
        let camera = GMSCameraPosition.camera(withLatitude: LocationManager.theLocationManager.getLocation().coordinate.latitude, longitude: LocationManager.theLocationManager.getLocation().coordinate.longitude, zoom: 12.0)
        homeMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        homeMapView.delegate = MapViewDelegate.theMapViewDelegate
        MapViewDelegate.theMapViewDelegate.googleMapView = homeMapView
        homeMapView.settings.myLocationButton = true
        homeMapView.isMyLocationEnabled = true
        homeMapView.settings.compassButton = true
        homeMapView.settings.indoorPicker = true
        
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
        mapListSegmentedControl.insertSegment(withTitle: "List", at: 1, animated: false)
        mapListSegmentedControl.selectedSegmentIndex = 0
        mapListSegmentedControl.addTarget(self, action: #selector(bringMapOrListToFront), for: .valueChanged)
        self.navigationItem.titleView = mapListSegmentedControl
    }
    
    func setupTopRightButtons(){
 
        filterButton = UIBarButtonItem(image:  #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(showFilterView))
        
        self.navigationItem.rightBarButtonItems = [filterButton]
    }
    
    func setupTopLeftButtons(){
        topLeftButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(menuAlert))
        
        self.navigationItem.leftBarButtonItems = [topLeftButton]
    }
    
    func setupBottomToolbar(){
        bottomToolbar = UIToolbar()
        bottomToolbar.backgroundColor = UIColor.white
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomToolbar)
        
        exploreButton = UIBarButtonItem(title: "Explore", style: .plain, target: self, action: #selector(goToExploreNavigationController))
        exploreButton.tintColor = UIColor.gray
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        compareButton = UIBarButtonItem(title: "Compare", style: .plain, target: self, action: #selector(goToCompareViewController))
        
        
        bottomToolbar.items = [exploreButton, flexibleSpace, compareButton]
    }
    
    @objc func goToExploreNavigationController(){
        
    }
    
    @objc func goToCompareViewController(){
        
        let compareVC = CompareListingsViewController()
        //compareVC.listingsArray = listingsToCompare
        
        present(compareVC, animated: false, completion: nil)
        
    }
    
    @objc func menuAlert(){
        
        let menuAlert = UIAlertController(title: "What would you like to do?", message: "", preferredStyle: .alert)
        
        let signInAction = UIAlertAction(title: "Sign in/Sign up", style: .default, handler: {(action) in
            
            let loginViewController = LoginViewController()
            self.present(loginViewController, animated: true, completion: nil)
        
        })
        
        let signOutAction = UIAlertAction(title: "Sign out", style: .destructive, handler: {(action) in
            
            let loginViewController = LoginViewController()
            self.present(loginViewController, animated: true, completion: nil)
            
        })
        
        let newPostAction = UIAlertAction(title: "Add a New Listing", style: .default, handler: {(action) in
            
            let postViewController = PostViewController()
            self.navigationController?.pushViewController(postViewController, animated: true)
        })
        
        let profileAction = UIAlertAction(title: "View My Profile", style: .default, handler: {(action) in
            let profileViewController = ProfileViewController()
            self.navigationController?.pushViewController(profileViewController, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if(guestUser){
            
            menuAlert.addAction(signInAction)
        }
        else {
            menuAlert.addAction(newPostAction)
            menuAlert.addAction(profileAction)
            menuAlert.addAction(signOutAction)
        }
        
        menuAlert.addAction(cancelAction)
        
        present(menuAlert, animated: true, completion: nil)
        
    }
    
    func setupLoadMoreButton(){
        loadMoreButton = UIButton()
        loadMoreButton.isOpaque = true
        loadMoreButton.addTarget(self, action: #selector(loadMoreListings), for: .touchUpInside)
        loadMoreButton.setTitle("Load more", for: .normal)
        loadMoreButton.backgroundColor = UIColor.white
        loadMoreButton.setTitleColor(UIColor.blue, for: .normal)
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        homeTableView.addSubview(loadMoreButton)
    }
    
    @objc func bringMapOrListToFront(){
        switch mapListSegmentedControl.selectedSegmentIndex {
        case 0:
            view.bringSubview(toFront: homeMapView)
        case 1:
            view.bringSubview(toFront: homeTableView)
        case 2:
            print("Gallery to be implemented")
        default:
            print("SHOULDNT RUN")
        }
    }
    
    @objc func loadMoreListings(){
        
        numberOfListingsToShow = numberOfListingsToShow + 3
        
        if(numberOfListingsToShow > listingsToPresent.count){
            numberOfListingsToShow = listingsToPresent.count
        }
        homeTableView.reloadData()
    }
    
    @objc func showSearchBar(){
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.delegate = self
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.isTranslucent = true
        //searchController?.searchBar.backgroundColor = UIColor.white
        
        // Include the search bar within the navigation bar.
        navigationItem.searchController = searchController
        //navigationItem.hidesSearchBarWhenScrolling = false
       searchController?.hidesNavigationBarDuringPresentation = false
        
        
        searchController?.searchBar.placeholder = "Search Address, Zip or City"

        definesPresentationContext = true
        
        navigationBarHeight = 56
    }
    
    func showSearchResults(){
        searchController?.searchBar.setShowsCancelButton(true, animated: true)
        
        searchController?.modalPresentationStyle = .popover
    }
    
    //NOT BEING USED
//    func setupSearchBar(){
//
//        searchBar = UISearchBar()
//        searchBar.frame = CGRect.zero
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.delegate = self
//        searchBar.placeholder = "Search Address, Zip or City"
//        searchBar.layer.zPosition = .greatestFiniteMagnitude
//        view.addSubview(searchBar)
//        searchBar.isHidden = false
//        view.bringSubview(toFront: searchBar)
//    }
    
 
    
    @objc func setInitialListingsToPresent(){
        
        //can change this when there are more than 3 listings for HomeSales and HomeRentals
        numberOfListingsToShow = 3
        
        //homesForSale will be default
        listingsToPresent = FirebaseData.sharedInstance.homesForSale
        
        sortListings()
        
        reloadMap()
        homeTableView.reloadData()
        
        
        //move this to another method called by another notification
      //  ReadFirebaseData.readCurrentUser(user: FirebaseData.sharedInstance.currentUser!)

        
    }
    
    func sortListings(){
        
        //sort the listings by proximity to chosen location
        if (chosenResultLocation == nil){
            listingsToPresent.sort(by: { $0.distance(to: LocationManager.theLocationManager.getLocation()) < $1.distance(to: LocationManager.theLocationManager.getLocation())})
        }
            
        //sort the listings by proximity to our location
        else {
            listingsToPresent.sort(by: { $0.distance(to: LocationManager.theLocationManager.getLocation()) < $1.distance(to: LocationManager.theLocationManager.getLocation())})
        }
    }
    
    @objc func reloadMap(){
        
        homeMapView.clear()
        
        MapViewDelegate.theMapViewDelegate.setupClusterManager()
        
        for listing in listingsToPresent{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: listing.coordinate.latitude, longitude: listing.coordinate.longitude)
            
            let priceTextView = UIView()
            priceTextView.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
            priceTextView.backgroundColor = UIColor.gray
            
            let priceLabel = UILabel()
            priceLabel.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
            priceLabel.textColor = UIColor.white
            priceLabel.textAlignment = .center
            
            if(listing.isKind(of: HomeRental.self)){
                let currentHomeRental = listing as! HomeRental
                priceLabel.text = shortenPriceLabel(price: currentHomeRental.monthlyRent, typeOfListing: "HomeRental")
            }
            else if (listing.isKind(of: HomeSale.self)){
                let currentHomeSale = listing as! HomeSale
                priceLabel.text = shortenPriceLabel(price: currentHomeSale.price, typeOfListing: "HomeSale")
            }
            
            priceTextView.addSubview(priceLabel)
            marker.iconView = priceTextView
           // marker.map = homeMapView
            
            let name = "Item \(listing.name)"
            
            let markerToAddToCluster = MapMarker.init(position: marker.position, name: name, marker: marker)
            //markerToAddToCluster.mapItem = listing
            
            MapViewDelegate.theMapViewDelegate.clusterManager.add(markerToAddToCluster)
        }
        
        MapViewDelegate.theMapViewDelegate.clusterManager.cluster()
        MapViewDelegate.theMapViewDelegate.clusterManager.setDelegate(MapViewDelegate.theMapViewDelegate, mapDelegate: MapViewDelegate.theMapViewDelegate)
    }
    
    func shortenPriceLabel(price: Int, typeOfListing: String) -> String{
        
        var returnText: String = ""
        
        switch typeOfListing {
        case "HomeSale":
            if (price > 999999){
                let returnPrice = String(format: "%.1f", Double(price/1000000))
                returnText = "$" + returnPrice + "M"
            }
                
            else if (price > 999){
                let returnPrice = String(format: "%.1f", Double(price/1000))
                returnText = "$" + returnPrice + "K"
            }
        case "HomeRental":
            returnText = "$\(price)/mth"
        default:
            returnText = "Unknown"
        }
        
        return returnText
    }
    
    func showListingPreview(listing: Listing){
        
        let storageRef = Storage.storage().reference()
        
        let tapGestureForListingPreview = UITapGestureRecognizer(target: self, action: #selector(goToListing))
        
        listingPreview = UIView()
        listingPreview.translatesAutoresizingMaskIntoConstraints = false
        listingPreview.backgroundColor = UIColor.white
        listingPreview.addGestureRecognizer(tapGestureForListingPreview)
        view.addSubview(listingPreview)
        
        previewImageView = UIImageView()
        previewImageView.sd_setImage(with: storageRef.child(listing.photoRefs[0]), placeholderImage: nil)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        listingPreview.addSubview(previewImageView)
        
        previewPriceLabel = UILabel()
        previewPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        listingPreview.addSubview(previewPriceLabel)
        
        previewSizeLabel = UILabel()
        previewSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        listingPreview.addSubview(previewSizeLabel)
        
        previewBedroomsNoLabel = UILabel()
        previewBedroomsNoLabel.translatesAutoresizingMaskIntoConstraints = false
        listingPreview.addSubview(previewBedroomsNoLabel)
        
        previewBathroomsNoLabel = UILabel()
        previewBathroomsNoLabel.translatesAutoresizingMaskIntoConstraints = false
        listingPreview.addSubview(previewBathroomsNoLabel)
        
        if(listing.isKind(of: HomeRental.self)){
            let currentHomeRental = listing as! HomeRental
            previewPriceLabel.text = "$\((currentHomeRental.monthlyRent)!)/month"
            previewSizeLabel.text = "\((currentHomeRental.size)!) SF"
            previewBedroomsNoLabel.text = "\((currentHomeRental.bedroomNumber)!) beds"
            previewBathroomsNoLabel.text = "\((currentHomeRental.bathroomNumber)!) baths"
        }
        else if (listing.isKind(of: HomeSale.self)){
            let currentHomeSale = listing as! HomeSale
            previewPriceLabel.text = "$\((currentHomeSale.price)!)"
            previewSizeLabel.text = "\((currentHomeSale.size)!) SF"
            previewBedroomsNoLabel.text = "\((currentHomeSale.bedroomNumber)!) beds"
            previewBathroomsNoLabel.text = "\((currentHomeSale.bathroomNumber)!) baths"
        }
        
        presentedListing = listing
        
        previewCancelButton = UIButton()
        previewCancelButton.setTitle("Cancel", for: .normal)
        previewCancelButton.setTitleColor(UIColor.red, for: .normal)
        previewCancelButton.backgroundColor = UIColor.white
        previewCancelButton.addTarget(self, action: #selector(removeListingPreview), for: .touchUpInside)
        previewCancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewCancelButton)
        
        setupListingPreviewConstraints()
        
    }
    
    @objc func removeListingPreview(){
        
        MapViewDelegate.theMapViewDelegate.selectedMarker.iconView?.subviews[0].backgroundColor = UIColor.gray
        listingPreview.removeFromSuperview()
        previewCancelButton.removeFromSuperview()
    }
    
    @objc func goToListing(){
    
        let listingDetailViewController = ListingDetailViewController()
        listingDetailViewController.currentListing = presentedListing
        
        self.navigationController?.pushViewController(listingDetailViewController, animated: true)
    }
    
    
    @objc func showFilterView(){
        let filterViewController = FilterViewController()
        filterViewController.theHomeViewController = self
        self.present(filterViewController, animated: true, completion: nil)
        
    }
    
    //notBeingUsed now
//    @objc func showHideFilterView(){
//        
//        if(!filterViewIsInFront){
//            
//            UIView.animate(withDuration: 0, animations: {
//                
//                
//            }, completion: { (finished: Bool) in
//                self.filterView.frame.size.height = self.filterViewHeight
//                self.filterView.isHidden = false
//            })
//            
//            view.bringSubview(toFront: filterView)
//            filterViewIsInFront = true
//            view.layoutIfNeeded()
//            
//            swipeUpGestureForFilterView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
//            swipeUpGestureForFilterView.direction = .up
//            filterView.addGestureRecognizer(swipeUpGestureForFilterView)
//        }
//            
//        else if (filterViewIsInFront){
//            UIView.animate(withDuration: 0, animations: {
//                
//            }, completion: { (finished: Bool) in
//                self.filterView.frame.size.height = 0
//                self.filterView.isHidden = true
//            })
//            
//            filterViewIsInFront = false
//            view.layoutIfNeeded()
//        }
//    }
    
    func setupConstraints(){
        
        //homeMapView
        NSLayoutConstraint(item: homeMapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeMapView, attribute: .bottom, relatedBy: .equal, toItem: bottomToolbar, attribute: .top , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeMapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeMapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: navigationBarHeight).isActive = true
        
        //homeTableView
        NSLayoutConstraint(item: homeTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .bottom, relatedBy: .equal, toItem: bottomToolbar, attribute: .top , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: navigationBarHeight).isActive = true
        
        //loadMoreButton
        NSLayoutConstraint(item: loadMoreButton, attribute: .centerX, relatedBy: .equal, toItem: homeTableView, attribute: .centerX , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadMoreButton, attribute: .bottom, relatedBy: .equal, toItem: bottomToolbar, attribute: .top , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadMoreButton, attribute: .width, relatedBy: .equal, toItem: homeTableView, attribute: .width , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadMoreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 20).isActive = true
        
        //bottomToolbar
        NSLayoutConstraint(item: bottomToolbar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bottomToolbar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bottomToolbar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bottomToolbar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 30).isActive = true
        
//        //searchBar
//        NSLayoutConstraint(item: searchController!.searchBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: searchController!.searchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: searchBarHeight).isActive = true
//        NSLayoutConstraint(item: searchController!.searchBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: searchController!.searchBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: navigationBarHeight).isActive = true
//        
        //filterView
//        NSLayoutConstraint(item: filterView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: filterView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: filterViewHeight).isActive = true
//        NSLayoutConstraint(item: filterView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: filterView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom , multiplier: 1, constant: 0).isActive = true
    }
    
    func setupListingPreviewConstraints(){
        
        //listingPreviewCancelButton
        NSLayoutConstraint(item: previewCancelButton, attribute: .bottom, relatedBy: .equal, toItem: view , attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: previewCancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: previewCancelButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: previewCancelButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        
        //listingPreview
        NSLayoutConstraint(item: listingPreview, attribute: .bottom, relatedBy: .equal, toItem: previewCancelButton , attribute: .top, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: listingPreview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        NSLayoutConstraint(item: listingPreview, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: listingPreview, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        
        //previewImageView
        NSLayoutConstraint(item: previewImageView, attribute: .bottom, relatedBy: .equal, toItem: listingPreview , attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: previewImageView, attribute: .top, relatedBy: .equal, toItem: listingPreview, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: previewImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: previewImageView, attribute: .width, relatedBy: .equal, toItem: previewImageView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        //previewPriceLabel
        NSLayoutConstraint(item: previewPriceLabel, attribute: .top, relatedBy: .equal, toItem: listingPreview, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: previewPriceLabel, attribute: .leading, relatedBy: .equal, toItem: previewImageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        
        //previewSizeLabel
        NSLayoutConstraint(item: previewSizeLabel, attribute: .top, relatedBy: .equal, toItem: previewPriceLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: previewSizeLabel, attribute: .leading, relatedBy: .equal, toItem: previewImageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        
        //previewBRLabel
        NSLayoutConstraint(item: previewBedroomsNoLabel, attribute: .top, relatedBy: .equal, toItem: previewSizeLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: previewBedroomsNoLabel, attribute: .leading, relatedBy: .equal, toItem: previewImageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        
        //previewBALabel
        NSLayoutConstraint(item: previewBathroomsNoLabel, attribute: .top, relatedBy: .equal, toItem: previewBedroomsNoLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: previewBathroomsNoLabel, attribute: .leading, relatedBy: .equal, toItem: previewImageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        
    }
    
    @objc func priceRangeSliderValueChanged(sender: RangeSlider){
        
        print("update")
    }
    
    //segues
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
    
    
    
    //tableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //can remove this later when we have many listings
        if (listingsToPresent.count < numberOfListingsToShow){
            return listingsToPresent.count
        }
        
        else {
            return numberOfListingsToShow
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storageRef = Storage.storage().reference()
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell") as! HomeTableViewCell
        
        let listing =  listingsToPresent[indexPath.row]
        
        if (listing.isKind(of: HomeSale.self)){
        //if (typeOfListingsDisplayed == "HomeSale"){
            let homeSale = listing as! HomeSale
            
            cell.bedroomsLabel.text = "\(homeSale.bedroomNumber!) br"
            cell.bathroomsLabel.text = "\(homeSale.bathroomNumber!) ba"
            cell.priceLabel.text = "$\(homeSale.price!)"
        }
        //else if (typeOfListingsDisplayed == "HomeRental"){
        else if (listing.isKind(of: HomeRental.self)){
            let homeRental = listingsToPresent[indexPath.row] as! HomeRental
            
            cell.bedroomsLabel.text = "\(homeRental.bedroomNumber!) br"
            cell.bathroomsLabel.text = "\(homeRental.bathroomNumber!) ba"
            cell.priceLabel.text = "$\(homeRental.monthlyRent!)/month"
        }
        
        cell.leftImageView.sd_setImage(with: storageRef.child(listing.photoRefs[0]), placeholderImage: nil)
        cell.leftImageView.contentMode = .scaleToFill
        //cell.nameLabel.text = listing.name
        cell.sizeLabel.text = "\(listing.size!) SF"
        //cell.addressLabel.text = listing.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listingViewController = ListingDetailViewController()
        
//        if (buyRentSegmentedControl.selectedSegmentIndex == 0){
//            listingViewController.currentListing = listingsToPresent![indexPath.row] as! HomeSale
//        }
//        else if (buyRentSegmentedControl.selectedSegmentIndex == 1){
//            listingViewController.currentListing = listingsToPresent![indexPath.row] as! HomeRental
//        }
        listingViewController.currentListing = listingsToPresent![indexPath.row]
        
        self.navigationController?.pushViewController(listingViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //swipe Up on filter view is not being used now
//    @objc func handleSwipeGestures(swipeGesture: UISwipeGestureRecognizer){
//
//        if(swipeGesture.direction == .up){
//            filterView.removeGestureRecognizer(swipeUpGestureForFilterView)
//            self.showHideFilterView()
//        }
//    }
    
    
    //searchBarDelegateMethods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

       // showSearchResults()

        tapGestureForTextFieldDelegate = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGestureForTextFieldDelegate)
        
      //  navigationBarHeight = self.navigationItem.searchController?.searchBar.frame.maxY
      //  setupConstraints()
        

//        swipeUpGestureForFilterView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
//        swipeUpGestureForFilterView.direction = .up
//        filterView.addGestureRecognizer(swipeUpGestureForFilterView)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchBarHeight = 40
        //self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
//        navigationBarHeight = (self.navigationItem.searchController?.searchBar.frame.maxY)! + 64
//
//        setupConstraints()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.removeGestureRecognizer(tapGestureForTextFieldDelegate)
        //searchBarHeight = 40
        //searchController?.searchBar.isHidden = true
        //self.searchBar.translatesAutoresizingMaskIntoConstraints = false
       // setupConstraints()
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        //searchBar.resignFirstResponder()
        //searchBarHeight = 40
        //self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    
    //GMSPlaceSearch Methods
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
    
    //GMSPLace Results handlers
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        let cameraUpdate = GMSCameraUpdate.setTarget(place.coordinate, zoom: 10.0)
        
        homeMapView.moveCamera(cameraUpdate)
        
        chosenResultLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        sortListings()
        
        homeTableView.reloadData()
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
