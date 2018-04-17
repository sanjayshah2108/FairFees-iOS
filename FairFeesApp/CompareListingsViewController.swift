//
//  CompareListingsViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-17.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class CompareListingsViewController: UIViewController {
    
    var listingsArray: [Listing]!
    weak var leftListing: Listing!
    weak var rightListing: Listing!
    
    var leftListingView: UIView!
    var rightListingView: UIView!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftListing()

        setupRightListing()
        
        setupMapView()
        
        setupConstraints()
    }
    
    func setupLeftListing(){
        
        leftListingView = UIView()
        leftListingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftListingView)
        
        leftListingImageView = UIImageView()
        leftListingImageView.backgroundColor = UIColor.blue
        leftListingImageView.translatesAutoresizingMaskIntoConstraints = false
        leftListingView.addSubview(leftListingImageView)
        
        leftListingPriceLabel = UILabel()
        leftListingPriceLabel.text = "Price"
        leftListingPriceLabel.textAlignment = .left
        leftListingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        leftListingView.addSubview(leftListingPriceLabel)
        
        leftListingSizeLabel = UILabel()
        leftListingSizeLabel.text = "Size"
        leftListingSizeLabel.textAlignment = .left
        leftListingSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        leftListingView.addSubview(leftListingSizeLabel)
        
        leftListingBedroomsLabel = UILabel()
        leftListingBedroomsLabel.text = "Brs"
        leftListingBedroomsLabel.textAlignment = .left
        leftListingBedroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        leftListingView.addSubview(leftListingBedroomsLabel)
        
        leftListingBathroomsLabel = UILabel()
        leftListingBathroomsLabel.text = "Bas"
        leftListingBathroomsLabel.textAlignment = .left
        leftListingBathroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        leftListingView.addSubview(leftListingBathroomsLabel)
        
    }
    
    func setupRightListing(){
        
        rightListingView = UIView()
        rightListingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightListingView)
        
        rightListingImageView = UIImageView()
        rightListingImageView.backgroundColor = UIColor.blue
        rightListingImageView.translatesAutoresizingMaskIntoConstraints = false
        rightListingView.addSubview(rightListingImageView)
        
        rightListingPriceLabel = UILabel()
        rightListingPriceLabel.text = "Price"
        rightListingPriceLabel.textAlignment = .right
        rightListingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        rightListingView.addSubview(rightListingPriceLabel)
        
        rightListingSizeLabel = UILabel()
        rightListingSizeLabel.text = "Price"
        rightListingSizeLabel.textAlignment = .right
        rightListingSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        rightListingView.addSubview(rightListingSizeLabel)
        
        rightListingBedroomsLabel = UILabel()
        rightListingBedroomsLabel.text = "Brs"
        rightListingBedroomsLabel.textAlignment = .right
        rightListingBedroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        rightListingView.addSubview(rightListingBedroomsLabel)
        
        rightListingBathroomsLabel = UILabel()
        rightListingBathroomsLabel.text = "Bas"
        rightListingBathroomsLabel.textAlignment = .right
        rightListingBathroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        rightListingView.addSubview(rightListingBathroomsLabel)
        
    }
    
    func setupMapView(){
        
        
    }

    func setupConstraints(){
        
        leftListingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        leftListingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leftListingView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        rightListingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rightListingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightListingView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        leftListingView.trailingAnchor.constraint(equalTo: rightListingView.leadingAnchor).isActive = true
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
