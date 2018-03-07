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
    
     var homeMapView: MKMapView!
     var homeTableView: UITableView!
     var mapListSegmentedControl: UISegmentedControl!
     var searchBar: UISearchBar!
     var filterView: UIView!
    
     var priceFilterSlider: UISlider!
     var noOfBedroomsSegmentedControl: UISegmentedControl!
     var applyFilterButton: UIButton!
    
    var navigationBarHeight: CGFloat!
    var tabBarHeight: CGFloat!
    var searchBarHeight: CGFloat!
    
    var tapGesture: UITapGestureRecognizer!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "homeTableViewCell")
        
        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        //view.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBarHeight = (self.navigationController?.navigationBar.frame.maxY)!
        tabBarHeight = self.tabBarController?.tabBar.frame.height
        searchBarHeight = 40
        
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

    func setupHomeMapView(){
        
        homeMapView = MKMapView()
        homeMapView.frame = CGRect.zero
        homeMapView.delegate = MapViewDelegate.theMapViewDelegate
       // homeMapView.
        view.addSubview(homeMapView)
        homeMapView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraint = NSLayoutConstraint(item: homeMapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: homeMapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom , multiplier: 1, constant: -tabBarHeight)
        let leadingConstraint = NSLayoutConstraint(item: homeMapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: homeMapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: (searchBarHeight + navigationBarHeight) )
        
        NSLayoutConstraint.activate([trailingConstraint, bottomConstraint, topConstraint, leadingConstraint])

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
        searchBar.placeholder = "Search Address, ZIp or City"
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
        priceFilterSlider.maximumValue = 100000
        priceFilterSlider.minimumValue = 10
        priceFilterSlider.setValue(3, animated: true)
        
        filterView.addSubview(priceFilterSlider)
        priceFilterSlider.translatesAutoresizingMaskIntoConstraints = false
        
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

        
        let noOfBedroomsSegmentedControlTrailingConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: 0)
        let noOfBedroomsSegmentedControlBottomConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .bottom, relatedBy: .equal, toItem: applyFilterButton, attribute: .top , multiplier: 1, constant: 0)
        let noOfBedroomsSegmentedControlLeadingConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 0)
        //let noOfBedroomsSegmentedControlTopConstraint = NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .top, relatedBy: .equal, toItem: filterView, attribute: .top , multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([noOfBedroomsSegmentedControlTrailingConstraint, noOfBedroomsSegmentedControlBottomConstraint, noOfBedroomsSegmentedControlLeadingConstraint])
        
        let applyFilterButtonTrailingConstraint = NSLayoutConstraint(item: applyFilterButton, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: 0)
        let applyFilterButtonBottomConstraint = NSLayoutConstraint(item: applyFilterButton, attribute: .bottom, relatedBy: .equal, toItem: applyFilterButton, attribute: .top , multiplier: 1, constant: 0)
        let applyFilterButtonLeadingConstraint = NSLayoutConstraint(item: applyFilterButton, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 0)
        let applyFilterButtonHeightConstraint = NSLayoutConstraint(item: applyFilterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        
        NSLayoutConstraint.activate([applyFilterButtonTrailingConstraint, applyFilterButtonBottomConstraint, applyFilterButtonLeadingConstraint, applyFilterButtonHeightConstraint])
        
    }
    
    @objc func applyFilters(){
        print("apply filters")
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.bringSubview(toFront: filterView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    
        self.view.removeGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

