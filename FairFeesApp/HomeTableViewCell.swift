//
//  HomeTableViewCell.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-07.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listingCellImageView: UIImageView!
    
    @IBOutlet weak var listingCellNameLabel: UILabel!
    
    @IBOutlet weak var listingCellAddressLabel: UILabel!
    
    @IBOutlet weak var listingCellPriceLabel: UILabel!
    
    @IBOutlet weak var listingCellSizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
