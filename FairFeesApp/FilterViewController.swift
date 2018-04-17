//
//  FilterViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit
import WARangeSlider

class FilterViewController: UIViewController {
    
    //var filterViewIsInFront: Bool!
    //var filterViewHeight: CGFloat!
    var theHomeViewController: HomeViewController!
    
    var logoImageView: UIImageView!
    var promptLabel: UILabel!
    var buyRentSegmentedControl: UISegmentedControl!
    var priceFilterSlider: RangeSlider!
    var priceFilterResultLabel: UILabel!
    var noOfBedroomsLabel: UILabel!
    var noOfBedroomsSegmentedControl: UISegmentedControl!
    var listingsCountLabel: UILabel!
    var applyFilterButton: UIButton!
    var resetFilterButton: UIButton!
    var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogo()
        setupFilters()
        setupLabels()
        setupButtons()
        setupConstraints()
    }

    func setupLogo(){
        
        logoImageView = UIImageView()
        logoImageView.backgroundColor = view.tintColor
        logoImageView.layer.cornerRadius = logoImageView.frame.width/2
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
    }
    
    func setupLabels(){
        promptLabel = UILabel()
        promptLabel.text = "What are you looking for?"
        promptLabel.textAlignment = .center
        promptLabel.textColor = UIColor.black
        promptLabel.font = UIFont(name: "Avenir-Light", size: 15)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(promptLabel)
        
        priceFilterResultLabel = UILabel()
        priceFilterResultLabel.text = "$\(Int(priceFilterSlider.lowerValue)) to $\(Int(priceFilterSlider.upperValue))"
        priceFilterResultLabel.font = UIFont(name: "GillSans-Light", size: 12)
        priceFilterResultLabel.translatesAutoresizingMaskIntoConstraints = false
        //priceFilterResultLabel.isHidden = true
        view.addSubview(priceFilterResultLabel)
        
        noOfBedroomsLabel = UILabel()
        noOfBedroomsLabel.text = "No. of Bedrooms"
        noOfBedroomsLabel.font = UIFont(name: "GillSans-Light", size: 10)
        noOfBedroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noOfBedroomsLabel)
        
        
        listingsCountLabel = UILabel()
        listingsCountLabel.text = String(theHomeViewController.listingsToPresent.count) + " listings found"
        listingsCountLabel.font = UIFont(name: "GillSans-Light", size: 15)
        listingsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listingsCountLabel)
        
    }
    
    func setupFilters(){

        view.backgroundColor = UIColor.white
        
        buyRentSegmentedControl = UISegmentedControl()
        buyRentSegmentedControl.insertSegment(withTitle: "Buy", at: 0, animated: false)
        buyRentSegmentedControl.insertSegment(withTitle: "Rent", at: 1, animated: false)
        buyRentSegmentedControl.selectedSegmentIndex = 0
        buyRentSegmentedControl.addTarget(self, action: #selector(applyBuyRentFilters), for: .valueChanged)
        buyRentSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buyRentSegmentedControl)
        
        priceFilterSlider = RangeSlider()
        view.addSubview(priceFilterSlider)
        priceFilterSlider.addTarget(self, action: #selector(applyFilters), for: .valueChanged)
        priceFilterSlider.maximumValue = 10000000
        priceFilterSlider.minimumValue = 500
        priceFilterSlider.lowerValue = 100000
        priceFilterSlider.upperValue = 5000000
        priceFilterSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceFilterSlider)
        
        noOfBedroomsSegmentedControl = UISegmentedControl()
        noOfBedroomsSegmentedControl.frame = CGRect.zero
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "1+", at: 0, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "2+", at: 1, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "3+", at: 2, animated: false)
        noOfBedroomsSegmentedControl.insertSegment(withTitle: "4+", at: 3, animated: false)
        noOfBedroomsSegmentedControl.addTarget(self, action: #selector(applyFilters), for: .valueChanged)
        noOfBedroomsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noOfBedroomsSegmentedControl)
        
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
        

    }
    
    func setupButtons(){
        applyFilterButton = UIButton()
        applyFilterButton.addTarget(self, action: #selector(applyFiltersAndDismiss), for: .touchUpInside)
        applyFilterButton.layer.cornerRadius = 5
        applyFilterButton.setTitle("Apply Filters", for: .normal)
        applyFilterButton.backgroundColor = view.tintColor
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyFilterButton)
        
        resetFilterButton = UIButton()
        resetFilterButton.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        resetFilterButton.layer.cornerRadius = 5
        resetFilterButton.setTitle("Reset Filters", for: .normal)
        resetFilterButton.backgroundColor = view.tintColor
        resetFilterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetFilterButton)
        
        cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = view.tintColor
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupConstraints(){
        
        //logoImageView
        NSLayoutConstraint(item: logoImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 70).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        
        //promptLabel
        NSLayoutConstraint(item: promptLabel, attribute: .top, relatedBy: .equal, toItem: logoImageView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: promptLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        //buyRentSegmentedControl
        NSLayoutConstraint(item: buyRentSegmentedControl, attribute: .top, relatedBy: .equal, toItem: promptLabel, attribute: .bottom , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: buyRentSegmentedControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 150).isActive = true
        NSLayoutConstraint(item: buyRentSegmentedControl, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: buyRentSegmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
        
        //priceFilterSlider
        NSLayoutConstraint(item: priceFilterSlider, attribute: .top, relatedBy: .equal, toItem: buyRentSegmentedControl, attribute: .bottom , multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsLabel, attribute: .top , multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: priceFilterSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 20).isActive = true
        
        //priceFilterSliderResultLabel
        NSLayoutConstraint(item: priceFilterResultLabel, attribute: .top, relatedBy: .equal, toItem: priceFilterSlider, attribute: .bottom , multiplier: 1, constant: 2).isActive = true
        //NSLayoutConstraint(item: priceFilterResultLabel, attribute: .trailing, relatedBy: .equal, toItem: filterView, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceFilterResultLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        //NSLayoutConstraint(item: priceFilterResultLabel, attribute: .leading, relatedBy: .equal, toItem: filterView, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        //NSLayoutConstraint(item: priceFilterResultLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsLabel, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //bedroomNumberLabel
        //NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .top, relatedBy: .equal, toItem: priceFilterSlider, attribute: .bottom , multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsLabel, attribute: .bottom, relatedBy: .equal, toItem: noOfBedroomsSegmentedControl, attribute: .top , multiplier: 1, constant: -5).isActive = true
        
        //bedroomNumberSegment
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: noOfBedroomsSegmentedControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
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
        NSLayoutConstraint(item: listingsCountLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX , multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: listingsCountLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: listingsCountLabel, attribute: .bottom, relatedBy: .equal, toItem: applyFilterButton, attribute: .top , multiplier: 1, constant: -15).isActive = true
        
        //applyFilterButton
        NSLayoutConstraint(item: applyFilterButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: applyFilterButton, attribute: .bottom, relatedBy: .equal, toItem: resetFilterButton, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //resetFilterButton
        NSLayoutConstraint(item: resetFilterButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: resetFilterButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: resetFilterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: resetFilterButton, attribute: .bottom, relatedBy: .equal, toItem: cancelButton, attribute: .top , multiplier: 1, constant: -10).isActive = true
        
        //cancelButton
        NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing , multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading , multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
    }
    
    @objc func applyBuyRentFilters(){
        
        switch buyRentSegmentedControl.selectedSegmentIndex {
        case 0:
            
            priceFilterSlider.maximumValue = 10000000
            priceFilterSlider.minimumValue = 100000
            priceFilterSlider.lowerValue = 100000
            priceFilterSlider.upperValue = 5000000
            
        case 1:
            priceFilterSlider.minimumValue = 500
            priceFilterSlider.maximumValue = 10000
            priceFilterSlider.lowerValue = 1000
            priceFilterSlider.upperValue = 1000000
            
        default:
            print("SHOULDN'T RUN")
        }
        
        applyFilters()
        
    }
    
    @objc func applyFilters(){
        
        switch noOfBedroomsSegmentedControl.selectedSegmentIndex {
        case 0:
            theHomeViewController.homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent.filter { $0.bedroomNumber > 0 }
            theHomeViewController.homeSalesToPresent = FirebaseData.sharedInstance.homesForSale.filter { $0.bedroomNumber > 0 }
        case 1:
            theHomeViewController.homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent.filter { $0.bedroomNumber > 1 }
            theHomeViewController.homeSalesToPresent = FirebaseData.sharedInstance.homesForSale.filter { $0.bedroomNumber > 1 }
        case 2:
            theHomeViewController.homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent.filter { $0.bedroomNumber > 2 }
            theHomeViewController.homeSalesToPresent = FirebaseData.sharedInstance.homesForSale.filter { $0.bedroomNumber > 2 }
        case 3:
            theHomeViewController.homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent.filter { $0.bedroomNumber > 3 }
            theHomeViewController.homeSalesToPresent = FirebaseData.sharedInstance.homesForSale.filter { $0.bedroomNumber > 3 }
            
        default:
            theHomeViewController.homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent
            theHomeViewController.homeSalesToPresent = FirebaseData.sharedInstance.homesForSale
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
        
        
        theHomeViewController.homeRentalsToPresent = theHomeViewController.homeRentalsToPresent.filter { ($0.monthlyRent > Int(priceFilterSlider.lowerValue)) && ($0.monthlyRent < Int(priceFilterSlider.upperValue)) }
        theHomeViewController.homeSalesToPresent = theHomeViewController.homeSalesToPresent.filter { ($0.price > Int(priceFilterSlider.lowerValue)) && ($0.price < Int(priceFilterSlider.upperValue)) }
        
        priceFilterResultLabel.text = "$\(Int(priceFilterSlider.lowerValue)) to  $\(Int(priceFilterSlider.upperValue))"
        
        
        switch buyRentSegmentedControl.selectedSegmentIndex {
        case 0:
            theHomeViewController.listingsToPresent = theHomeViewController.homeSalesToPresent
            
        case 1:
            theHomeViewController.listingsToPresent = theHomeViewController.homeRentalsToPresent
            
        default:
            print("SHOULDN'T RUN")
        }
        
        listingsCountLabel.text = String(theHomeViewController.listingsToPresent.count) + " listings found"
        theHomeViewController.reloadMap()
        theHomeViewController.homeTableView.reloadData()
    
    }
    
    @objc func applyFiltersAndDismiss(){
        applyFilters()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func resetFilters(){
        
        theHomeViewController.homeRentalsToPresent = FirebaseData.sharedInstance.homesForRent
        theHomeViewController.homeSalesToPresent = FirebaseData.sharedInstance.homesForSale
        
       // priceFilterSlider.lowerValue = 1000
        //priceFilterSlider.upperValue = 1000000
       // priceFilterResultLabel.text = "$\(Int(priceFilterSlider.lowerValue)) to  $\(Int(priceFilterSlider.upperValue))"
        
        switch buyRentSegmentedControl.selectedSegmentIndex {
        case 0:
            theHomeViewController.listingsToPresent = theHomeViewController.homeSalesToPresent
        case 1:
            theHomeViewController.listingsToPresent = theHomeViewController.homeRentalsToPresent
        default:
            print("SHOULDN'T RUN")
        }
        
        listingsCountLabel.text = String(theHomeViewController.listingsToPresent.count) + " listings found"
        theHomeViewController.reloadMap()
        theHomeViewController.homeTableView.reloadData()
        
    }
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
}
