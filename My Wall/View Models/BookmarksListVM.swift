//
//  BookmarksListVM.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/29/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation

class BookmarksListVM {
    
    var wallpapers = [WallpaperVM]()
    var bookmarksService:BookmarkService!
    
    init() {
        bookmarksService = BookmarkService(moc: AppDelegate.moc)
    }
    
    
    
}
