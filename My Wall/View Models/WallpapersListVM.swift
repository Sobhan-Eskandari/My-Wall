//
//  WallpapersListVM.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/27/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation

class WallpapersListVM {
    
    var webservice:WebService!
    var wallpapers:[WallpaperVM] = []
    var bookmarksService:BookmarkService!
    
    init() {
        bookmarksService = BookmarkService(moc: AppDelegate.moc)
    }
    
    func getWallpapers(webservice:WebService ,completion:@escaping ()->()) {
        self.webservice = webservice
        webservice.getWallpapers { (wallpapers, error) in
            if let error = error {
                print("error:\(error)")
                fatalError()
            }
            self.wallpapers += wallpapers.compactMap(WallpaperVM.init)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func deleteBookmark(id:Int32) {
        bookmarksService.deleteBookmark(id: id)
    }
    
    func getBookmarks(completion:@escaping (()->())) {
        
        if let cWallpapers = bookmarksService.getAllBookmarks() {
            self.wallpapers = cWallpapers.compactMap(WallpaperVM.init)
            completion()
        }
    }
    
    func saveBookmark(wallpaper:WallpaperVM) {
        bookmarksService.addBookmark(sBookmark: wallpaper)
    }
    
}

class WallpaperVM {
    
    let largeImageURL: String
    let webformatHeight, webformatWidth, likes, imageWidth: Int
    let id, userID: Int
    let imageURL: String
    let views, comments: Int
    let pageURL: String
    let imageHeight: Int
    let webformatURL: String
    let idHash, type: String
    let previewHeight: Int
    let tags: String
    let downloads: Int
    let user: String
    let favorites, imageSize, previewWidth: Int
    let userImageURL, fullHDURL, previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case largeImageURL, webformatHeight, webformatWidth, likes, imageWidth, id
        case userID = "user_id"
        case imageURL, views, comments, pageURL, imageHeight, webformatURL
        case idHash = "id_hash"
        case type, previewHeight, tags, downloads, user, favorites, imageSize, previewWidth, userImageURL, fullHDURL, previewURL
    }
    
    init(wallpaper:Wallpaper) {
        self.largeImageURL = wallpaper.largeImageURL
        self.webformatHeight = wallpaper.webformatHeight
        self.webformatWidth = wallpaper.webformatWidth
        self.likes = wallpaper.likes
        self.imageWidth = wallpaper.imageWidth
        self.id = wallpaper.id
        self.userID = wallpaper.userID
        self.imageURL = wallpaper.imageURL
        self.views = wallpaper.views
        self.comments = wallpaper.comments
        self.pageURL = wallpaper.pageURL
        self.imageHeight = wallpaper.imageHeight
        self.webformatURL = wallpaper.webformatURL
        self.idHash = wallpaper.idHash
        self.type = wallpaper.type
        self.previewHeight = wallpaper.previewHeight
        self.tags = wallpaper.tags
        self.downloads = wallpaper.downloads
        self.user = wallpaper.user
        self.favorites = wallpaper.favorites
        self.imageSize = wallpaper.imageSize
        self.previewWidth = wallpaper.previewWidth
        self.userImageURL = wallpaper.userImageURL
        self.fullHDURL = wallpaper.fullHDURL
        self.previewURL = wallpaper.previewURL
    }
    
    init(wallpaper:Bookmark) {
        self.largeImageURL = wallpaper.largeImageURL!
        self.webformatHeight = Int(wallpaper.webformatHeight)
        self.webformatWidth = Int(wallpaper.webformatWidth)
        self.likes = Int(wallpaper.likes)
        self.imageWidth = Int(wallpaper.imageWidth)
        self.id = Int(wallpaper.id)
        self.userID = Int(wallpaper.userID)
        self.imageURL = wallpaper.imageURL!
        self.views = Int(wallpaper.views)
        self.comments = Int(wallpaper.comments)
        self.pageURL = wallpaper.pageURL!
        self.imageHeight = Int(wallpaper.imageHeight)
        self.webformatURL = wallpaper.webformatURL!
        self.idHash = wallpaper.idHash!
        self.type = wallpaper.type!
        self.previewHeight = Int(wallpaper.previewHeight)
        self.tags = wallpaper.tags!
        self.downloads = Int(wallpaper.downloads)
        self.user = wallpaper.user!
        self.favorites = Int(wallpaper.favorites)
        self.imageSize = Int(wallpaper.imageSize)
        self.previewWidth = Int(wallpaper.previewWidth)
        self.userImageURL = wallpaper.userImageURL!
        self.fullHDURL = wallpaper.fullHDURL!
        self.previewURL = wallpaper.previewURL!
    }
    
    
}
