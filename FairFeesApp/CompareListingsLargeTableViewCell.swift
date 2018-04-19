//
//  CompareListingsLargeTableViewCell.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-18.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class CompareListingsLargeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var bedroomsLabel: UILabel!
    @IBOutlet weak var bathroomsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
