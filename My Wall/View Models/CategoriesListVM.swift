//
//  CategoriesListVM.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/27/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation
import UIKit

class CategoriesListVM {
    
    var categories:[CategoryVM] = []
    
    init(completion:@escaping (Int)->()) {
        let fashion = CategoryVM(title: "Fashion")
        let nature = CategoryVM(title: "Nature")
        let backgrounds = CategoryVM(title: "Backgrounds")
        
        let science = CategoryVM(title: "Science")
        let education = CategoryVM(title: "Education")
        let people = CategoryVM(title: "People")
       
        let feelings = CategoryVM(title: "Feelings")
        let religion = CategoryVM(title: "Religion")
        let health = CategoryVM(title: "Health")
        
        let places = CategoryVM(title: "Places")
        let animals = CategoryVM(title: "Animals")
        let industry = CategoryVM(title: "Industry")
        
        let food = CategoryVM(title: "Food")
        let computer = CategoryVM(title: "Computer")
        let sports = CategoryVM(title: "Sports")
        
        let transportation = CategoryVM(title: "Transportation")
        let travel = CategoryVM(title: "Travel")
        let buildings = CategoryVM(title: "Buildings")
        
        let business = CategoryVM(title: "Business")
        let music = CategoryVM(title: "Music")
        
        categories.append(fashion)
        categories.append(nature)
        categories.append(backgrounds)
        categories.append(science)
        categories.append(education)
        categories.append(people)
        categories.append(feelings)
        categories.append(religion)
        categories.append(health)
        categories.append(places)
        categories.append(animals)
        categories.append(industry)
        categories.append(food)
        categories.append(computer)
        categories.append(sports)
        categories.append(transportation)
        categories.append(travel)
        categories.append(buildings)
        categories.append(business)
        categories.append(music)
        
        let _ = categories.enumerated().compactMap { (index,category) in
            category.getWallpaper {
                completion(index)
            }
        }
        
        
    }
}

class CategoryVM {
    
    var title:String
    var wallpapersListVM:WallpapersListVM!
    var completion:()->() = {}
    
    init(title:String) {
        self.title = title
    }
    
    func getWallpaper(completion:@escaping ()->()) {
        let params:[String:String] = [
            "category":title.lowercased(),
            "per_page":"6",
            "pretty":"true",
            "editors_choice":"true"
        ]
        let websrevice = WebService(params: params)
        wallpapersListVM = WallpapersListVM()
        wallpapersListVM.getWallpapers(webservice: websrevice) {
            completion()
        }
    }
    
}
