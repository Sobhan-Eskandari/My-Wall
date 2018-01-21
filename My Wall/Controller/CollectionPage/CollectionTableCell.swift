//
//  CollectionTableCell.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 12/1/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit
import Ambience

class CollectionTableCell: UITableViewCell {

    static let identifier = "collectionCell"
    
    @IBOutlet weak var collectionBc: UIView!
    @IBOutlet weak var featuredTitle: UILabel!
    @IBOutlet weak var seeMoreBtn: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var topRightImage: UIImageView!
    @IBOutlet weak var bottomRightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionBc.layer.borderWidth = 2.0
        collectionBc.layer.borderColor = UIColor.white.cgColor
        collectionBc.layer.cornerRadius = 10
        collectionBc.layer.shadowOpacity = 1.0
        collectionBc.layer.shadowRadius = 10
        collectionBc.layer.shadowColor = UIColor(red:168/255.0 , green:182/255.0 , blue:200/255.0 , alpha: 1.0).cgColor
        mainImage.roundCorners([.topLeft, .bottomLeft], radius: 10)
        topRightImage.roundCorners([.topRight], radius: 10)
        bottomRightImage.roundCorners([.bottomRight], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override func ambience(_ notification : Notification) {
        
        super.ambience(notification)
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        let defaults = UserDefaults.standard
        let darkMode = defaults.bool(forKey: "darkMode")
        
        print("Darkmode",currentState)
        if(currentState.rawValue == "invert"){
            defaults.set(true, forKey: "darkMode")
           collectionBc.layer.shadowColor = UIColor.clear.cgColor
        }else if (currentState.rawValue == "regular" && darkMode){
            defaults.set(false, forKey: "darkMode")
            collectionBc.layer.shadowColor = UIColor(red:168/255.0 , green:182/255.0 , blue:200/255.0 , alpha: 1.0).cgColor
        }
    }


}

extension UIImageView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
