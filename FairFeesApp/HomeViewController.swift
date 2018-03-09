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


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UISearchBarDelegate {
    
     var locationManager: CLLocationManager!
    
     var homeMapView: MKMapView!
     var homeTableView: UITableView!
     var mapListSegmentedControl: UISegmentedControl!
    var topRightButton: UIBarButtonItem!
     var searchBar: UISearchBar!
     var filterView: UIView!
    
     var priceFilterSlider: UISlider!
     var noOfBedroomsLabel: UILabel!
     var noOfBedroomsSegmentedControl: UISegmentedControl!
     var applyFilterButton: UIButton!
    
    var navigationBarHeight: CGFloat!
    var tabBarHeight: CGFloat!
    var searchBarHeight: CGFloat!
    
    var tapGesture: UITapGestureRecognizer!
    var swipeUpGesture: UISwipeGestureRecognizer!


    override func viewDidLoad() {
        super.viewDidLoad()
   
        locationManager = LocationManager.theLocationManager
        
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        tabBarHeight = self.tabBarController?.tabBar.frame.height
        searchBarHeight = 40
        
        setupDummyData()
        
        setupMapListSegmentTitle()
        setupTopRightButton()
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
        
        MapViewDelegate.theMapViewDelegate.theMapView = homeMapView
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
        
        homeMapView = MKMapView()
        homeMapView.frame = CGRect.zero
        homeMapView.delegate = MapViewDelegate.theMapViewDelegate
        MapViewDelegate.theMapViewDelegate.theMapView = homeMapView
        MapViewDelegate.theMapViewDelegate.setHomeVCMapRegion()
        homeMapView.showsUserLocation = true
     
        view.addSubview(homeMapView)
        homeMapView.translatesAutoresizingMaskIntoConstraints = false
        
        homeMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "listingMarkerView")
        
        homeMapView.addAnnotations(DummyData.theDummyData.homesForSale)
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
    
    func setupSearchBar(){
        searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: navigationBarHeight, width: view.frame.width, height: 40)
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
        NSLayoutConstraint(item: homeMapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: -tabBarHeight).isActive = true
        NSLayoutConstraint(item: homeMapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeMapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: (searchBarHeight + navigationBarHeight)).isActive = true
        
        
        //homeTableView
        NSLayoutConstraint(item: homeTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: -tabBarHeight).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: homeTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: (navigationBarHeight+searchBarHeight)).isActive = true

        //searchBar
        NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: searchBarHeight).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: homeMapView, attribute: .top , multiplier: 1, constant: 0).isActive = true
        
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
        
//        if (cell == nil){
//            tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewCell")
//        }
        
        let listing = DummyData.theDummyData.homesForSale[indexPath.row]
        
        cell.listingCellNameLabel.text = listing.listingName
        cell.listingCellSizeLabel.text = "\(listing.listingSize!) SF"
        cell.listingCellPriceLabel.text = "$\(listing.salePrice!)"
        cell.listingCellAddressLabel.text = listing.listingAddress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listingViewController = ListingDetailViewController()
        listingViewController.currentListing = DummyData.theDummyData.homesForSale[indexPath.row]
        
        self.navigationController?.pushViewController(listingViewController, animated: true)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @objc func handleSwipeGestures(swipeGesture: UISwipeGestureRecognizer){
        
        if(swipeGesture.direction == .up){
            view.sendSubview(toBack: filterView)
            filterView.removeGestureRecognizer(swipeUpGesture)
        }
        
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.bringSubview(toFront: filterView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestures))
        swipeUpGesture.direction = .up
        filterView.addGestureRecognizer(swipeUpGesture)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    
        self.view.removeGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

