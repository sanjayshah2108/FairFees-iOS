//
//  CompareListingsTableViewCell.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-18.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class CompareListingsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
