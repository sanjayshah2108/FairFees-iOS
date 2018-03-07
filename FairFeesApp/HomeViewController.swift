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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DummyData.theDummyData.homesForSale.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "homeTableViewCell")
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "homeTableViewCell")
        
        let listing = DummyData.theDummyData.homesForSale[indexPath.row]
        
        cell.textLabel?.text = listing.listingName
        
        
        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        //view.translatesAutoresizingMaskIntoConstraints = false
    
    
        
        locationManager = LocationManager.theLocationManager
        
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        tabBarHeight = self.tabBarController?.tabBar.frame.height
        searchBarHeight = 40
        
        setupDummyData()
        
        setupMapListSegmentTitle()
        setupHomeMapView()
        setupHomeTableView()
        setupSearchBar()
        setupFilterView()
    
        view.bringSubview(toFront: homeMapView)
        view.bringSubview(toFront: searchBar)
      
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
        MapViewDelegate.theMapViewDelegate.setMapRegion()
        homeMapView.showsUserLocation = true
        
       // homeMapView.
        view.addSubview(homeMapView)
        homeMapView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraint = NSLayoutConstraint(item: homeMapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: homeMapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: -tabBarHeight)
        let leadingConstraint = NSLayoutConstraint(item: homeMapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: homeMapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: (searchBarHeight + navigationBarHeight) )
        
        NSLayoutConstraint.activate([trailingConstraint, bottomConstraint, topConstraint, leadingConstraint])
        
        homeMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "listingMarkerView")
        homeMapView.addAnnotation(DummyData.theDummyData.homesForSale[0] as! MKAnnotation)

    }
    
    func setupHomeTableView(){
        homeTableView = UITableView()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.frame = CGRect.zero
        view.addSubview(homeTableView)
        homeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraint = NSLayoutConstraint(item: homeTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: homeTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: -tabBarHeight)
        let leadingConstraint = NSLayoutConstraint(item: homeTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: homeTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: (navigationBarHeight+searchBarHeight))
        
        NSLayoutConstraint.activate([trailingConstraint, bottomConstraint, topConstraint, leadingConstraint])

    }
    
    func setupMapListSegmentTitle(){
        mapListSegmentedControl = UISegmentedControl()
        mapListSegmentedControl.insertSegment(withTitle: "Map", at: 0, animated: false)
        mapListSegmentedControl.insertSegment(withTitle: "List", at: 2, animated: false)
        mapListSegmentedControl.selectedSegmentIndex = 0
        mapListSegmentedControl.addTarget(self, action: #selector(bringMapOrListToFront), for: .valueChanged)
        self.navigationItem.titleView = mapListSegmentedControl
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
    
    func setupSearchBar(){
        searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: navigationBarHeight, width: view.frame.width, height: 40)
        searchBar.delegate = self
        searchBar.placeholder = "Search Address, Zip or City"
        view.addSubview(searchBar)
        view.bringSubview(toFront: searchBar)
        
        let searchBarTrailingConstraint = NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0)
        let searchBarHeightConstraint = NSLayoutConstraint(item: searchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: searchBarHeight)
        let searchBarLeadingConstraint = NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0)
        let searchBarBottomConstraint = NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: homeMapView, attribute: .top , multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([searchBarTrailingConstraint, searchBarHeightConstraint, searchBarLeadingConstraint, searchBarBottomConstraint])
        
    }
    
    func setupFilterView(){
        filterView = UIView(frame: CGRect(x: 0, y: navigationBarHeight + 40, width: view.frame.width, height: 200))
        filterView.backgroundColor = UIColor.gray
        view.addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        priceFilterSlider = UISlider()
        priceFilterSlider.maximumValue = 10000000
        priceFilterSlider.minimumValue = 100000
        
        priceFilterSlider.setValue(100000, animated: true)
        
        filterView.addSubview(priceFilterSlider)
        priceFilterSlider.translatesAutoresizingMaskIntoConstraints = false
        
        noOfBedroomsLabel = UILabel()
        noOfBedroomsLabel.text = "No. of Bedrooms"
        filterView.addSubview(noOfBedroomsLabel)
        noOfBedroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noOfBedroomsSegmentedControl = UISegmentedControl()
        noOfBedroomsSegmentedControl.frame = CGRect.zero
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "1+", at: 0, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "2+", at: 1, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "3+", at: 2, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "4+", at: 3, animated: false)
        
        filterView.addSubview(noOfBedroomsSegmentedControl)
        noOfBedroomsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        applyFilterButton = UIButton()
        applyFilterButton.frame = CGRect.zero
        applyFilterButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        applyFilterButton.layer.cornerRadius = 5
        applyFilterButton.setTitle("Apply Filters", for: .normal)
        applyFilterButton.backgroundColor = UIColor.white
        applyFilterButton.titleLabel?.textColor = UIColor.black
        filterView.addSubview(applyFilterButton)
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        
        let filterViewTrailingConstraint = NSLayoutConstraint(item: filterView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0)
        let filterViewHeightConstraint = NSLayoutConstraint(item: filterView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 200)
        let filterViewLeadingConstraint = NSLayoutConstraint(item: filterView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0)
        let filterViewTopConstraint = NSLayoutConstraint(item: filterView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom , multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([filterViewTrailingConstraint, filterViewHeightConstraint, filterViewLeadingConstraint, filterViewTopConstraint])
        
        let priceFilterSliderTrailingConstraint = NSLayoutConstraint(item: priceFilterSlider, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: 0)
        let priceFilterSliderBottomConstraint = NSLayoutConstraint(item: priceFilterSlider, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsSegmentedControl, attribute: .top , multiplier: 1, constant: 0)
        let priceFilterSliderLeadingConstraint = NSLayoutConstraint(item: priceFilterSlider, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 0)
        let priceFilterSliderTopConstraint = NSLayoutConstraint(item: priceFilterSlider, attribute: .top, relatedBy: .equal, toItem: filterView, attribute: .top , multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([priceFilterSliderTrailingConstraint, priceFilterSliderBottomConstraint, priceFilterSliderLeadingConstraint, priceFilterSliderTopConstraint])

        //let noOfBedroomsLabelTrailingConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: 0)
        let noOfBedroomsLabelBottomConstraint = NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsSegmentedControl, attribute: .top , multiplier: 1, constant: 5)
        let noOfBedroomsLabelLeadingConstraint = NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 0)
        let noOfBedroomsLabelTopConstraint = NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .top, relatedBy: .equal, toItem: priceFilterSlider, attribute: .bottom , multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([noOfBedroomsLabelBottomConstraint, noOfBedroomsLabelLeadingConstraint, noOfBedroomsLabelTopConstraint])
        
        let noOfBedroomsSegmentedControlTrailingConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: 0)
        //let noOfBedroomsSegmentedControlBottomConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: applyFilterButton, attribute: .top , multiplier: 1, constant: 5)
        let noOfBedroomsSegmentedControlLeadingConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 0)
        let noOfBedroomsSegmentedControlTopConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .top, relatedBy: .equal, toItem: noOfBedroomsLabel, attribute: .bottom , multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([noOfBedroomsSegmentedControlTrailingConstraint, noOfBedroomsSegmentedControlTopConstraint, noOfBedroomsSegmentedControlLeadingConstraint])
        
        let applyFilterButtonTrailingConstraint = NSLayoutConstraint(item: applyFilterButton, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10)
        let applyFilterButtonBottomConstraint = NSLayoutConstraint(item: applyFilterButton, attribute: .bottom, relatedBy: .equal, toItem: filterView, attribute: .bottom , multiplier: 1, constant: -20)
        let applyFilterButtonLeadingConstraint = NSLayoutConstraint(item: applyFilterButton, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10)
        let applyFilterButtonHeightConstraint = NSLayoutConstraint(item: applyFilterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        
        NSLayoutConstraint.activate([applyFilterButtonTrailingConstraint, applyFilterButtonBottomConstraint, applyFilterButtonLeadingConstraint, applyFilterButtonHeightConstraint])
        
    }
    
    @objc func applyFilters(){
        print("apply filters")
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

