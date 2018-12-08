//
//  Bookmark+CoreDataProperties.swift
//  
//
//  Created by Sobhan Eskandari on 11/29/18.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var id: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var pageURL: String?
    @NSManaged public var imageHeight: Int16
    @NSManaged public var webformatURL: String?
    @NSManaged public var type: String?
    @NSManaged public var previewHeight: Int16
    @NSManaged public var user: String?
    @NSManaged public var imageSize: Int32
    @NSManaged public var previewWidth: Int16
    @NSManaged public var userImageURL: String?
    @NSManaged public var fullHDURL: String?
    @NSManaged public var previewURL: String?
    @NSManaged public var largeImageURL: String?
    @NSManaged public var webformatHeight: Int16
    @NSManaged public var webformatWidth: Int16
    @NSManaged public var likes: Int16
    @NSManaged public var imageWidth: Int16
    @NSManaged public var userID: Int32
    @NSManaged public var views: Int32
    @NSManaged public var comments: Int32
    @NSManaged public var idHash: String?
    @NSManaged public var tags: String?
    @NSManaged public var downloads: Int32
    @NSManaged public var favorites: Int32

}
