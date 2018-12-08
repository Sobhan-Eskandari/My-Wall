//
//  BookmarksCollectionController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/26/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import UIKit
import Hero

private let reuseIdentifier = "bookmarkCell"

class BookmarksCollectionController: UICollectionViewController {

    var wallpapersListVM:WallpapersListVM!
    var selectedIndex = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup navigation controller
        Extensions.clearNavbar(controller: self.navigationController!)
        self.collectionView.backgroundColor = ColorPallet.MainColor()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wallpapersListVM = WallpapersListVM()
        wallpapersListVM.getBookmarks {
            print(self.wallpapersListVM.wallpapers)
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return wallpapersListVM == nil ? 0 : wallpapersListVM.wallpapers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WallpaperCell
        cell.wallImage.kf.setImage(with: URL(string: wallpapersListVM.wallpapers[indexPath.row].previewURL))
        cell.wallImage.hero.id = "image_\(wallpapersListVM.wallpapers[indexPath.row].id)"
        cell.wallImage.hero.modifiers = [.fade, .scale(0.8)]
        cell.wallImage.isOpaque = true
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "imageViewer") as! ImageViewController
        vc.selectedIndex = indexPath
        vc.wallpapers = wallpapersListVM
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}

//MARK: - PINTEREST LAYOUT DELEGATE
extension BookmarksCollectionController : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return CGFloat(wallpapersListVM.wallpapers[indexPath.item].previewHeight)
    }
    
}
