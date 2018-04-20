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
    
    var leftListingImageView: UIImageView!
    var leftListingPriceLabel: UILabel!
    var leftListingSizeLabel: UILabel!
    var leftListingBedroomsLabel: UILabel!
    var leftListingBathroomsLabel: UILabel!
    
    var rightListingImageView: UIImageView!
    var rightListingPriceLabel: UILabel!
    var rightListingSizeLabel: UILabel!
    var rightListingBedroomsLabel: UILabel!
    var rightListingBathroomsLabel: UILabel!
    
    var mapView: GMSMapView!
    var polylinesToShow: [GMSPolyline]!
    var leftPolyline: GMSPolyline!
    var leftDistanceLabel: UILabel!
    var leftMarker: GMSMarker!
    var rightPolyline: GMSPolyline!
    var rightDistanceLabel: UILabel!
    var rightMarker: GMSMarker!

    var bottomToolbar: UIToolbar!
    var exploreButton: UIBarButtonItem!
    var compareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ReadFirebaseData.readCurrentUser(user: FirebaseData.sharedInstance.currentUser!)
        
      
        listingsArray = FirebaseData.sharedInstance.currentUser?.compareListingsStack
        
        view.backgroundColor = UIColor.white
        
        setupLeftListing()

        setupRightListing()
        
        setupChildViewControllers()
        
        setupMapView()
        
        setupBottomToolbar()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = UIColor.white
        view.addSubview(statusBarView)
        
        setupConstraints()
        setupLeftListingConstraints()
        setupRightListingConstraints()
        
        
    }
    
    func setupChildViewControllers(){
        
        leftListingContainerView = UIView()
        leftListingContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftListingContainerView)
        
        leftListingCompareTableViewController = CompareListingsTableViewController()
        leftListingCompareTableViewController.tableViewID = 0
        leftListingCompareTableViewController.listingsArray = listingsArray
        //addViewControllerAsChildViewController(childViewController: leftListingCompareTableViewController)
        addChildViewController(leftListingCompareTableViewController)
        leftListingContainerView.addSubview(leftListingCompareTableViewController.view)
        leftListingCompareTableViewController.view.frame = leftListingContainerView.bounds
        leftListingCompareTableViewController.didMove(toParentViewController: self)
        
        rightListingCompareTableViewController = CompareListingsTableViewController()
        rightListingCompareTableViewController.tableViewID = 1
        rightListingCompareTableViewController.listingsArray = listingsArray
        //addViewControllerAsChildViewController(childViewController: rightListingCompareTableViewController)
        addChildViewController(rightListingCompareTableViewController)
        rightListingContainerView.addSubview(rightListingCompareTableViewController.view)
        rightListingCompareTableViewController.view.frame = rightListingContainerView.bounds
        rightListingCompareTableViewController.didMove(toParentViewController: self)
        
    }
    
    func setupLeftListing(){
        
        leftListingContainerView = UIView()
        leftListingContainerView.translatesAutoresizingMaskIntoConstraints = false
        leftListingContainerView.backgroundColor = .white
        view.addSubview(leftListingContainerView)
        
        leftListingImageView = UIImageView()
        leftListingImageView.backgroundColor = view.tintColor
        leftListingImageView.translatesAutoresizingMaskIntoConstraints = false
        leftListingContainerView.addSubview(leftListingImageView)
        
        leftListingPriceLabel = UILabel()
        leftListingPriceLabel.text = "Price"
        leftListingPriceLabel.textAlignment = .left
        leftListingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        leftListingContainerView.addSubview(leftListingPriceLabel)
        
        leftListingSizeLabel = UILabel()
        leftListingSizeLabel.text = "Size"
        leftListingSizeLabel.textAlignment = .left
        leftListingSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        leftListingContainerView.addSubview(leftListingSizeLabel)
        
        leftListingBedroomsLabel = UILabel()
        leftListingBedroomsLabel.text = "Brs"
        leftListingBedroomsLabel.textAlignment = .left
        leftListingBedroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        leftListingContainerView.addSubview(leftListingBedroomsLabel)
        
        leftListingBathroomsLabel = UILabel()
        leftListingBathroomsLabel.text = "Bas"
        leftListingBathroomsLabel.textAlignment = .left
        leftListingBathroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        leftListingContainerView.addSubview(leftListingBathroomsLabel)
        
    }
    
    func setupRightListing(){
        
        rightListingContainerView = UIView()
        rightListingContainerView.backgroundColor = .white
        rightListingContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightListingContainerView)
        
        rightListingImageView = UIImageView()
        rightListingImageView.backgroundColor = view.tintColor
        rightListingImageView.translatesAutoresizingMaskIntoConstraints = false
        rightListingContainerView.addSubview(rightListingImageView)
        
        rightListingPriceLabel = UILabel()
        rightListingPriceLabel.text = "Price"
        rightListingPriceLabel.textAlignment = .right
        rightListingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        rightListingContainerView.addSubview(rightListingPriceLabel)
        
        rightListingSizeLabel = UILabel()
        rightListingSizeLabel.text = "Price"
        rightListingSizeLabel.textAlignment = .right
        rightListingSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        rightListingContainerView.addSubview(rightListingSizeLabel)
        
        rightListingBedroomsLabel = UILabel()
        rightListingBedroomsLabel.text = "Brs"
        rightListingBedroomsLabel.textAlignment = .right
        rightListingBedroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        rightListingContainerView.addSubview(rightListingBedroomsLabel)
        
        rightListingBathroomsLabel = UILabel()
        rightListingBathroomsLabel.text = "Bas"
        rightListingBathroomsLabel.textAlignment = .right
        rightListingBathroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        rightListingContainerView.addSubview(rightListingBathroomsLabel)
        
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
        
        // bottomToolbar.
        bottomToolbar.items = [exploreButton, flexibleSpace, compareButton]
    }
    
    @objc func goToExploreNavigationController(){
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func goToCompareViewController(){
        
//        let compareVC = CompareListingsViewController()
//        compareVC.listingsArray = listingsToCompare
//
//        present(compareVC, animated: true, completion: nil)
        
    }

    func setupConstraints(){
        
        //leftListingView
        NSLayoutConstraint(item: leftListingContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftListingContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftListingContainerView, attribute: .trailing, relatedBy: .equal, toItem: rightListingContainerView, attribute: .leading , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftListingContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY , multiplier: 1, constant: 0).isActive = true
        
        //rightListingView
        //NSLayoutConstraint(item: rightListingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 0).isActive = true
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
    
    func setupLeftListingConstraints(){
        
        //leftListingImageView
        NSLayoutConstraint(item: leftListingImageView, attribute: .centerX, relatedBy: .equal, toItem: leftListingContainerView, attribute: .centerX , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftListingImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: leftListingImageView, attribute: .top, relatedBy: .equal, toItem: leftListingContainerView, attribute: .top , multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: leftListingImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 80).isActive = true
        
        //leftListingPriceLabel
        NSLayoutConstraint(item: leftListingPriceLabel, attribute: .leading, relatedBy: .equal, toItem: leftListingContainerView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: leftListingPriceLabel, attribute: .top, relatedBy: .equal, toItem: leftListingImageView, attribute: .bottom , multiplier: 1, constant: 30).isActive = true
        
        //leftListingSizeLabel
        NSLayoutConstraint(item: leftListingSizeLabel, attribute: .leading, relatedBy: .equal, toItem: leftListingContainerView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: leftListingSizeLabel, attribute: .top, relatedBy: .equal, toItem: leftListingPriceLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        
        //leftListingBedroomsLabel
        NSLayoutConstraint(item: leftListingBedroomsLabel, attribute: .leading, relatedBy: .equal, toItem: leftListingContainerView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: leftListingBedroomsLabel, attribute: .top, relatedBy: .equal, toItem: leftListingSizeLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        
        //leftListingBathroomsLabel
        NSLayoutConstraint(item: leftListingBathroomsLabel, attribute: .leading, relatedBy: .equal, toItem: leftListingContainerView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: leftListingBathroomsLabel, attribute: .top, relatedBy: .equal, toItem: leftListingBedroomsLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        
        
    }
    
    func setupRightListingConstraints(){
        
        //rightListingImageView
        NSLayoutConstraint(item: rightListingImageView, attribute: .centerX, relatedBy: .equal, toItem: rightListingContainerView, attribute: .centerX , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: rightListingImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: rightListingImageView, attribute: .top, relatedBy: .equal, toItem: leftListingContainerView, attribute: .top , multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: rightListingImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 80).isActive = true
        
        //rightListingPriceLabel
        NSLayoutConstraint(item: rightListingPriceLabel, attribute: .trailing, relatedBy: .equal, toItem: rightListingContainerView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: rightListingPriceLabel, attribute: .top, relatedBy: .equal, toItem: rightListingImageView, attribute: .bottom , multiplier: 1, constant: 30).isActive = true
        
        //rightListingSizeLabel
        NSLayoutConstraint(item: rightListingSizeLabel, attribute: .trailing, relatedBy: .equal, toItem: rightListingContainerView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: rightListingSizeLabel, attribute: .top, relatedBy: .equal, toItem: rightListingPriceLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        
        //rightListingBedroomsLabel
        NSLayoutConstraint(item: rightListingBedroomsLabel, attribute: .trailing, relatedBy: .equal, toItem: rightListingContainerView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: rightListingBedroomsLabel, attribute: .top, relatedBy: .equal, toItem: rightListingSizeLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        
        //rightListingBathroomsLabel
        NSLayoutConstraint(item: rightListingBathroomsLabel, attribute: .trailing, relatedBy: .equal, toItem: rightListingContainerView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: rightListingBathroomsLabel, attribute: .top, relatedBy: .equal, toItem: rightListingBedroomsLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
