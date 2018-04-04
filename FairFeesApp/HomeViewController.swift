
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
    var searchBar: UISearchBar!
    var filterView: UIView!
    var filterViewIsInFront: Bool!
    var filterViewHeight: CGFloat!
    
    var buyRentSegmentedControl: UISegmentedControl!
    var priceFilterSlider: RangeSlider!
    var priceFilterResultLabel: UILabel!
    var noOfBedroomsLabel: UILabel!
    var noOfBedroomsSegmentedControl: UISegmentedControl!
    //var noOfBathroomsLabel: UILabel!
    //var noOfBathroomsSegmentedControl: UISegmentedControl!
    var listingsCountLabel: UILabel!
    var applyFilterButton: UIButton!
    var resetFilterButton: UIButton!
    
    var navigationBarHeight: CGFloat!
    var searchBarHeight: CGFloat!
    
    var tapGestureForTextFieldDelegate: UITapGestureRecognizer!
    var swipeUpGestureForFilterView: UISwipeGestureRecognizer!
    var tapGestureForListingPreview: UITapGestureRecognizer!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var listingsToPresent: [Listing]!
    var homeSalesToPresent: [HomeSale]!
    var homeRentalsToPresent: [HomeRental]!
    
    var listingPreview: UIView!
    var previewCancelButton : UIButton!
    var previewImageView: UIImageView!
    var previewPriceLabel: UILabel!
    var previewSizeLabel: UILabel!
    var previewBedroomsNoLabel: UILabel!
    var previewBathroomsNoLabel: UILabel!
    
  
    var presentedListing: Listing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guestUser = true
        locationManager = LocationManager.theLocationManager
        
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        searchBarHeight = 0
        filterViewHeight = 220
        
        setupMapListSegmentTitle()
        setupTopRightButtons()
        setupTopLeftButtons()
        
        listingsToPresent = []
        homeSalesToPresent = []
        homeRentalsToPresent = []
        
        setupHomeMapView()
        setupHomeTableView()
        setupSearchBar()
        setupFilterView()
        
        setupConstraints()
        
        //right now we are only being notified when rentals are downloaded, because they are being dowloaded last
        NotificationCenter.default.addObserver(self, selector: #selector(setInitialListingsToPresent), name: NSNotification.Name(rawValue: "rentalHomesDownloadCompleteNotificationKey"), object: nil)
        
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
        topRightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPostAction))
        profileButton =  UIBarButtonItem(title: "Prof", style: .plain, target: self, action: #selector(profileViewControllerSegue))
        
        self.navigationItem.rightBarButtonItems = [profileButton, topRightButton]
    }
    
    func setupTopLeftButtons(){
        topLeftButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        filterButton = UIBarButtonItem(image:  #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(showHideFilterView))
        
        self.navigationItem.leftBarButtonItems = [topLeftButton, filterButton]
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
        
        if(filterViewIsInFront){
            view.bringSubview(toFront: filterView)
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
        filterView.backgroundColor = UIColor.white
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        
        buyRentSegmentedControl = UISegmentedControl()
        buyRentSegmentedControl.insertSegment(withTitle: "Buy", at: 0, animated: false)
        buyRentSegmentedControl.insertSegment(withTitle: "Rent", at: 1, animated: false)
        buyRentSegmentedControl.selectedSegmentIndex = 0
        buyRentSegmentedControl.addTarget(self, action: #selector(applyFilters), for: .valueChanged)
        buyRentSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(buyRentSegmentedControl)
        
        priceFilterSlider = RangeSlider()
        filterView.addSubview(priceFilterSlider)
        priceFilterSlider.addTarget(self, action: #selector(applyFilters), for: .valueChanged)
        priceFilterSlider.maximumValue = 10000000
        priceFilterSlider.minimumValue = 500
        priceFilterSlider.lowerValue = 1000
        priceFilterSlider.upperValue = 1000000
        priceFilterSlider.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(priceFilterSlider)
        
        priceFilterResultLabel = UILabel()
        priceFilterResultLabel.text = "$\(Int(priceFilterSlider.lowerValue)) to $\(Int(priceFilterSlider.upperValue))"
        priceFilterResultLabel.font = UIFont(name: "GillSans-Light", size: 12)
        priceFilterResultLabel.translatesAutoresizingMaskIntoConstraints = false
        //priceFilterResultLabel.isHidden = true
        filterView.addSubview(priceFilterResultLabel)
        
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
        noOfBedroomsSegmentedControl.addTarget(self, action: #selector(applyFilters), for: .valueChanged)
        noOfBedroomsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(noOfBedroomsSegmentedControl)
        
//        noOfBathroomsLabel = UILabel()
//        noOfBathroomsLabel.text = "No. of Bathrooms"
//        noOfBathroomsLabel.font = UIFont(name: "GillSans-Light", size: 10)
//        noOfBathroomsLabel.translatesAutoresizingMaskIntoConstraints = false
//        filterView.addSubview(noOfBathroomsLabel)
//
//        noOfBathroomsSegmentedControl = UISegmentedControl()
//        noOfBathroomsSegmentedControl.frame = CGRect.zero
//        noOfBathroomsSegmentedControl.insertSegment(withTitle: "1+", at: 0, animated: false)
//        noOfBathroomsSegmentedControl.insertSegment(withTitle: "2+", at: 1, animated: false)
//        noOfBathroomsSegmentedControl.insertSegment(withTitle: "3+", at: 2, animated: false)
//        noOfBathroomsSegmentedControl.insertSegment(withTitle: "4+", at: 3, animated: false)
//        noOfBathroomsSegmentedControl.addTarget(self, action: #selector(applyFilters), for: .valueChanged)
//        noOfBathroomsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        filterView.addSubview(noOfBathroomsSegmentedControl)
        
        listingsCountLabel = UILabel()
        listingsCountLabel.text = String(listingsToPresent.count) + " listings found"
        listingsCountLabel.font = UIFont(name: "GillSans-Light", size: 15)
        listingsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(listingsCountLabel)
        
        applyFilterButton = UIButton()
        applyFilterButton.frame = CGRect.zero
        applyFilterButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        applyFilterButton.layer.cornerRadius = 5
        applyFilterButton.setTitle("Apply Filters", for: .normal)
        applyFilterButton.backgroundColor = UIColor.blue
        applyFilterButton.titleLabel?.textColor = UIProperties.sharedUIProperties.primaryBlackColor
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(applyFilterButton)
        
        resetFilterButton = UIButton()
        resetFilterButton.frame = CGRect.zero
        resetFilterButton.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        resetFilterButton.layer.cornerRadius = 5
        resetFilterButton.setTitle("Reset Filters", for: .normal)
        resetFilterButton.backgroundColor = UIColor.blue
        resetFilterButton.titleLabel?.textColor = UIProperties.sharedUIProperties.primaryBlackColor
        resetFilterButton.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(resetFilterButton)
        
        filterViewIsInFront = false
    }
    
    @objc func setInitialListingsToPresent(){
        
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
        
        reloadMapAndTable()
        
    }
    
    @objc func reloadMapAndTable(){
        
        homeMapView.clear()
        
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
                // priceLabel.text = "$\((currentHomeRental.monthlyRent)!)/month"
            }
            else if (listing.isKind(of: HomeSale.self)){
                let currentHomeSale = listing as! HomeSale
                priceLabel.text = shortenPriceLabel(price: currentHomeSale.price, typeOfListing: "HomeSale")
                //priceLabel.text = "$\((currentHomeSale.price)!)"
            }
            
            priceTextView.addSubview(priceLabel)
            marker.iconView = priceTextView
            marker.map = homeMapView
        }
        
        homeTableView.reloadData()
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
    
    @objc func applyFilters(){
        
        switch noOfBedroomsSegmentedControl.selectedSegmentIndex {
        case 0:
            homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent.filter { $0.bedroomNumber > 0 }
            homeSalesToPresent = FirebaseData.sharedInstance.homesForSale.filter { $0.bedroomNumber > 0 }
        case 1:
            homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent.filter { $0.bedroomNumber > 1 }
            homeSalesToPresent = FirebaseData.sharedInstance.homesForSale.filter { $0.bedroomNumber > 1 }
        case 2:
            homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent.filter { $0.bedroomNumber > 2 }
            homeSalesToPresent = FirebaseData.sharedInstance.homesForSale.filter { $0.bedroomNumber > 2 }
        case 3:
            homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent.filter { $0.bedroomNumber > 3 }
            homeSalesToPresent = FirebaseData.sharedInstance.homesForSale.filter { $0.bedroomNumber > 3 }
            
        default:
            homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent
            homeSalesToPresent = FirebaseData.sharedInstance.homesForSale
        }
        
//        switch noOfBathroomsSegmentedControl.selectedSegmentIndex {
//        case 0:
//            homeRentalsToPresent = homeRentalsToPresent.filter { $0.bathroomNumber > 0 }
//            homeSalesToPresent = homeSalesToPresent.filter { $0.bathroomNumber > 0 }
//        case 1:
//            homeRentalsToPresent = homeRentalsToPresent.filter { $0.bathroomNumber > 1 }
//            homeSalesToPresent = homeSalesToPresent.filter { $0.bathroomNumber > 1 }
//        case 2:
//            homeRentalsToPresent = homeRentalsToPresent.filter { $0.bathroomNumber > 2 }
//            homeSalesToPresent = homeSalesToPresent.filter { $0.bathroomNumber > 2 }
//        case 3:
//            homeRentalsToPresent = homeRentalsToPresent.filter { $0.bathroomNumber > 3 }
//            homeSalesToPresent = homeSalesToPresent.filter { $0.bathroomNumber > 3 }
//
//        default:
//            print("no need to change anything?")
//            //homeRentalsToPresent = homeRentalsToPresent
//            //homeSalesToPresent = homeSalesToPresent
//        }
        
        
        homeRentalsToPresent = homeRentalsToPresent.filter { ($0.monthlyRent > Int(priceFilterSlider.lowerValue)) && ($0.monthlyRent < Int(priceFilterSlider.upperValue)) }
        homeSalesToPresent = homeSalesToPresent.filter { ($0.price > Int(priceFilterSlider.lowerValue)) && ($0.price < Int(priceFilterSlider.upperValue)) }
        
        priceFilterResultLabel.text = "$\(Int(priceFilterSlider.lowerValue)) to  $\(Int(priceFilterSlider.upperValue))"
        
        
        switch buyRentSegmentedControl.selectedSegmentIndex {
        case 0:
            listingsToPresent = homeSalesToPresent
        case 1:
            listingsToPresent = homeRentalsToPresent
        default:
            print("SHOULDN'T RUN")
        }
        
        listingsCountLabel.text = String(listingsToPresent.count) + " listings found"
        reloadMapAndTable()
    }
    
    @objc func resetFilters(){
        
        homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent
        homeSalesToPresent = FirebaseData.sharedInstance.homesForSale
        
        priceFilterSlider.lowerValue = 1000
        priceFilterSlider.upperValue = 1000000
        priceFilterResultLabel.text = "$\(Int(priceFilterSlider.lowerValue)) to  $\(Int(priceFilterSlider.upperValue))"
        
        switch buyRentSegmentedControl.selectedSegmentIndex {
        case 0:
            listingsToPresent = homeSalesToPresent
        case 1:
            listingsToPresent = homeRentalsToPresent
        default:
            print("SHOULDN'T RUN")
        }
        
        listingsCountLabel.text = String(listingsToPresent.count) + " listings found"
        reloadMapAndTable()
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
            
            swipeUpGestureForFilterView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
            swipeUpGestureForFilterView.direction = .up
            filterView.addGestureRecognizer(swipeUpGestureForFilterView)
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
        NSLayoutConstraint(item: priceFilterSlider, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsLabel, attribute: .top , multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 20).isActive = true
        
        //priceFilterSliderResultLabel
        NSLayoutConstraint(item: priceFilterResultLabel, attribute: .top, relatedBy: .equal, toItem: priceFilterSlider, attribute: .bottom , multiplier: 1, constant: 2).isActive = true
        //NSLayoutConstraint(item: priceFilterResultLabel, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceFilterResultLabel, attribute: .centerX, relatedBy: .equal, toItem: filterView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        //NSLayoutConstraint(item: priceFilterResultLabel, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        //NSLayoutConstraint(item: priceFilterResultLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsLabel, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //bedroomNumberLabel
        //NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .top, relatedBy: .equal, toItem: priceFilterSlider, attribute: .bottom , multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsSegmentedControl, attribute: .top , multiplier: 1, constant: -5).isActive = true
        
        //bedroomNumberSegment
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: listingsCountLabel, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //bathroomNumberLabel
//        NSLayoutConstraint(item: noOfBathroomsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: noOfBathroomsLabel, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: noOfBathroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBathroomsSegmentedControl, attribute: .top , multiplier: 1, constant: -5).isActive = true
        
        //bathroomNumberSegment
//        NSLayoutConstraint(item: noOfBathroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
//        NSLayoutConstraint(item: noOfBathroomsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: noOfBathroomsSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
//        NSLayoutConstraint(item: noOfBathroomsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: listingsCountLabel, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //listingsCountLabel
        NSLayoutConstraint(item: listingsCountLabel, attribute: .centerX, relatedBy: .equal, toItem: filterView, attribute: .centerX , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsCountLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: listingsCountLabel, attribute: .bottom, relatedBy: .equal, toItem: applyFilterButton, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //applyFilterButton
        NSLayoutConstraint(item: applyFilterButton, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .bottom, relatedBy: .equal, toItem: resetFilterButton, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //resetFilterButton
        NSLayoutConstraint(item: resetFilterButton, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: resetFilterButton, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: resetFilterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: resetFilterButton, attribute: .bottom, relatedBy: .equal, toItem: filterView, attribute: .bottom , multiplier: 1, constant: -10).isActive = true
        
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
            filterView.removeGestureRecognizer(swipeUpGestureForFilterView)
            self.showHideFilterView()
        }
    }
    
    //searchBarDelegateMethods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        tapGestureForTextFieldDelegate = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGestureForTextFieldDelegate)
        
        swipeUpGestureForFilterView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
        swipeUpGestureForFilterView.direction = .up
        filterView.addGestureRecognizer(swipeUpGestureForFilterView)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchBarHeight = 40
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        self.navigationItem.rightBarButtonItem = topRightButton
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.removeGestureRecognizer(tapGestureForTextFieldDelegate)
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
