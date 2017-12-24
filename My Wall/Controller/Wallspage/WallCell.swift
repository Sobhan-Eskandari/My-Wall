//
//  WallCell.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/28/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit
import INSPhotoGallery

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
