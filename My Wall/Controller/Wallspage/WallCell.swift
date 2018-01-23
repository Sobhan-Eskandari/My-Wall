//
//  WallCell.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/28/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit
import INSPhotoGallery
import Ambience

class WallCell: UICollectionViewCell {
    static let identifier = "wallCell"
    
    @IBOutlet weak var wallImage: UIImageView!
    @IBOutlet weak var wallImageView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        wallImageView.layer.borderWidth = 2.0
        wallImageView.layer.borderColor = UIColor.white.cgColor
        wallImageView.layer.cornerRadius = 10
        wallImage.layer.cornerRadius = 10
        wallImageView.layer.shadowOpacity = 1.0
        wallImageView.layer.shadowRadius = 5
        wallImageView.layer.shadowColor = UIColor(red:168/255.0 , green:182/255.0 , blue:200/255.0 , alpha: 1.0).cgColor
        wallImageView.layer.cornerRadius = 10
        
        let defaults = UserDefaults.standard
        let darkMode = defaults.bool(forKey: "darkMode")
        
        
        if(darkMode){
            defaults.set(true, forKey: "darkMode")
            wallImageView.layer.shadowColor = UIColor.clear.cgColor
            wallImageView.layer.shadowOpacity = 0.0
            print("Dar1")
        }else if (!darkMode){
            defaults.set(false, forKey: "darkMode")
            wallImageView.layer.shadowColor = UIColor(red:168/255.0 , green:182/255.0 , blue:200/255.0 , alpha: 1.0).cgColor
        }
    }
    
    public override func ambience(_ notification : Notification) {
        
        super.ambience(notification)
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        let defaults = UserDefaults.standard
        let darkMode = defaults.bool(forKey: "darkMode")
        
        print("Darkmode",currentState)
        if(currentState.rawValue == "invert"){
            defaults.set(true, forKey: "darkMode")
            wallImageView.layer.shadowColor = UIColor.clear.cgColor
        }else if (currentState.rawValue == "regular" && darkMode){
            defaults.set(false, forKey: "darkMode")
            wallImageView.layer.shadowColor = UIColor(red:168/255.0 , green:182/255.0 , blue:200/255.0 , alpha: 1.0).cgColor
        }
    }
    
    func populateWithPhoto(_ photo: INSPhotoViewable) {
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.wallImage.image = image
            }
        }
    }

}
