//
//  PlanCell.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/29/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit

class PlanCell: UICollectionViewCell {
   
    @IBOutlet weak var gradientBc: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var purchaseBtnLayout: UIButton!
    
    static let identifier = "subscriptionCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
