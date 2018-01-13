//
//  Urls.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 12/3/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import Foundation

struct Urls {
    var raw:String? //fullHDURL in pixabay
    var full:String? //largeImageURL in pixabay
    var regular:String?
    var small:String?
    var thumb:String?
    
    init(smallImage:String) {
        self.small = smallImage
        raw = nil
        full = nil
        regular = nil
        thumb = nil
    }
    init(regularImage:String) {
        small = nil
        raw = nil
        full = nil
        regular = regularImage
        thumb = nil
    }
}
