//
//  CardInfoLayout.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 1/16/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation

class CardLayoutInfo {
    var cardImages:Image
    var fullQualityUrl: String
    var downloadedImage:[UIImage] = []
    var imageUrl = ""
    var photographerURL = ""
    var photographerName = ""
    
    init(cardImages:Image,fullQualityUrl: String,photographerURL:String,photographerName:String,imageUrl:String) {
        self.cardImages = cardImages
        self.fullQualityUrl = fullQualityUrl
        self.photographerURL = photographerURL
        self.photographerName = photographerName
        self.imageUrl = imageUrl
    }

}
