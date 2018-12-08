//
//  SearchVM.swift
//  News
//
//  Created by Sobhan Eskandari on 11/9/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchVM:NSObject {
    
    let searchController = UISearchController(searchResultsController: nil)
    var completion:(WallpapersListVM)->() = { _ in }
    var moc:NSManagedObjectContext!
    var webservice:WebService!
    var wallpapersListVM:WallpapersListVM!
    
    init(completion:@escaping (WallpapersListVM)->()) {
        super.init()
        self.completion = completion
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Wallpapers..."
        searchController.searchBar.delegate = self
    }
    
    func getSearchController() -> UISearchController {
        return searchController
    }
    
}

extension SearchVM: UISearchResultsUpdating,UISearchBarDelegate {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var perpage = 20
        if UIDevice.current.userInterfaceIdiom == .pad {
            perpage = 60
        }else{
            perpage = 20
        }
        let params:[String:String] = [
            "q":"\(searchBar.text!)",
            "pretty":"true",
            "per_page":"\(perpage)",
            "editors_choice":"true"
        ]
        webservice = WebService(params: params)
        wallpapersListVM = WallpapersListVM()
        wallpapersListVM.getWallpapers(webservice: webservice) {
            self.completion(self.wallpapersListVM)
        }
        searchBar.resignFirstResponder()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
