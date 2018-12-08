//
//  HomeCollectionController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/23/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import UIKit
import Kingfisher
import Hero
import GoogleMobileAds

private let reuseIdentifier = "wallpaperCell"

class HomeCollectionController: UICollectionViewController {

    // MARK: - Variables
    var searchVM:SearchVM!
    var webservice:WebService!
    var wallpapersListVM:WallpapersListVM!
    var selectedCategory:String?
    var pageTitle = "Your Wall"
    var selectedIndex = IndexPath(row: 0, section: 0)
    var categories = ["fashion","nature","backgrounds","science","education","people","feelings","religion","health","places","animals","industry","food","computer","sports","transportation","travel","buildings","business","music"]
    var loadingCell:LoadingCell!
    var loadedMore = false
    var selectedPage = arc4random_uniform(6) + 1
    var params:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var selectedCat = ""
        if let category = selectedCategory {
            selectedCat = category
        } else {
            let randomIndex = Int(arc4random_uniform(UInt32(categories.count)))
            selectedCat = categories[randomIndex]
        }
        
        var perpage = 20
        if UIDevice.current.userInterfaceIdiom == .pad {
            perpage = 60
        }else{
            perpage = 20
        }
        params = [
            "category":selectedCat,
            "pretty":"true",
            "page": "\(selectedPage)",
            "per_page": "\(perpage)",
            "editors_choice":"true"
        ]
        webservice = WebService(params: params)
        wallpapersListVM = WallpapersListVM()
        wallpapersListVM.getWallpapers(webservice: webservice) {
            self.collectionView.reloadData()
        }
        
        // Setup the Search Controller View
        searchVM = SearchVM(completion: { (wallpapersVM) in
            self.wallpapersListVM = wallpapersVM
            self.collectionView.reloadData()
        })
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchVM.getSearchController()
        } else {
            navigationItem.titleView = searchVM.getSearchController().searchBar
        }
        definesPresentationContext = true
        
        // Setup navigation controller
        Extensions.clearNavbar(controller: self.navigationController!)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        self.title = pageTitle
        self.collectionView.backgroundColor = ColorPallet.MainColor()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return wallpapersListVM.wallpapers.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == self.wallpapersListVM.wallpapers.count  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            self.loadingCell = cell
            cell.loading.startAnimating()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WallpaperCell
            cell.wallImage.kf.setImage(with: URL(string: wallpapersListVM.wallpapers[indexPath.row].previewURL))
            cell.wallImage.hero.id = "image_\(wallpapersListVM.wallpapers[indexPath.row].id)"
            cell.wallImage.hero.modifiers = [.fade, .scale(0.8)]
            cell.wallImage.isOpaque = true
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.wallpapersListVM.wallpapers.count  { } else {
            self.selectedIndex = indexPath
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "imageViewer") as! ImageViewController
            vc.selectedIndex = indexPath
            vc.wallpapers = wallpapersListVM
            self.present(vc, animated: true, completion: nil)
        }
    }
    
  
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let cell = self.collectionView.cellForItem(at: IndexPath(row: self.wallpapersListVM.wallpapers.count, section: 0)) as! LoadingCell
        if self.loadingCell != nil {
            if isVisible(view: self.loadingCell) && loadedMore == false {
                loadedMore = true
                params["page"] = "\(selectedPage + 1)"
                selectedPage += 1
                webservice = WebService(params: params)
                wallpapersListVM.getWallpapers(webservice: webservice) {
                    self.collectionView.reloadData()
                    self.loadedMore = false
                    print("loaded infos")
                }
                print("loading cell")
            }
        }
    }
    
    public func isVisible(view: UIView) -> Bool {
        
        if view.window == nil {
            return false
        }
        
        var currentView: UIView = view
        while let superview = currentView.superview {
            
            if (superview.bounds).intersects(currentView.frame) == false {
                return false;
            }
            
            if currentView.isHidden {
                return false
            }
            
            currentView = superview
        }
        
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}

//MARK: - PINTEREST LAYOUT DELEGATE
extension HomeCollectionController : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if indexPath.row == self.wallpapersListVM.wallpapers.count {
            return 40
        } else {
            return CGFloat(wallpapersListVM.wallpapers[indexPath.item].previewHeight)
        }
    }
    
}

