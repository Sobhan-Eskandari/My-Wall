//
//  HomeCarouselCell.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/24/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//


import UIKit

class HomeCarouselCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    static let identifier = "HomeCarouselCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
