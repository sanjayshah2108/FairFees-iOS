//
//  AlertDefault.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-06.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class AlertDefault: NSObject {
    
    class func showAlert(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okayAction)
        
        return alert        
    }

}
