//
//  BookmarkService.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/28/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation
import CoreData

class BookmarkService {
    
    let moc:NSManagedObjectContext
    var bookmarks = [Bookmark]()
    
    init(moc:NSManagedObjectContext) {
        self.moc = moc
    }
    
    // CREATE
    func addBookmark(sBookmark:WallpaperVM) {
        if !isExist(id: Int32(sBookmark.id)) {
            let bookmark = Bookmark(context: moc)
            bookmark.id = Int32(sBookmark.id)
            bookmark.comments = Int32(sBookmark.comments)
            bookmark.downloads = Int32(sBookmark.downloads)
            bookmark.favorites = Int32(sBookmark.favorites)
            bookmark.fullHDURL = sBookmark.fullHDURL
            bookmark.idHash = sBookmark.idHash
            bookmark.imageHeight = Int16(sBookmark.imageHeight)
            bookmark.imageSize = Int32(sBookmark.imageSize)
            bookmark.imageURL = sBookmark.imageURL
            bookmark.imageWidth = Int16(sBookmark.imageWidth)
            bookmark.largeImageURL = sBookmark.largeImageURL
            bookmark.likes = Int16(sBookmark.likes)
            bookmark.pageURL = sBookmark.pageURL
            bookmark.previewHeight = Int16(sBookmark.previewHeight)
            bookmark.previewURL = sBookmark.previewURL
            bookmark.previewWidth = Int16(sBookmark.previewWidth)
            bookmark.tags = sBookmark.tags
            bookmark.type = sBookmark.type
            bookmark.user = sBookmark.user
            bookmark.userID = Int32(sBookmark.userID)
            bookmark.userImageURL = sBookmark.userImageURL
            bookmark.views = Int32(sBookmark.views)
            bookmark.webformatHeight = Int16(sBookmark.webformatHeight)
            bookmark.webformatURL = sBookmark.webformatURL
            bookmark.webformatWidth = Int16(sBookmark.webformatWidth)
            bookmarks.append(bookmark)
            save()
        }
    }
    
    func deleteBookmark(id:Int32) {
        let request:NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        let bookmark = try! moc.fetch(request)[0]
        moc.delete(bookmark)
        save()
    }
    
    func getAllBookmarks() -> [Bookmark]? {
        let request:NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        do {
            bookmarks = try moc.fetch(request)
            return bookmarks
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func isExist(id:Int32) -> Bool {
        let fetchRequest:NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        let res = try! moc.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    func save() {
        do {
            try moc.save()
        } catch {
            print("Saving Error:\(error)")
        }
    }
    
}
