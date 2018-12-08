//
//  CategoryCell.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/26/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import UIKit

protocol WallpaperCellTapped {
    func seeMoreTapped(category:String)
}

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var wallpaperCollectionView: UICollectionView!
    @IBOutlet weak var title: UILabel!
    var delegate:WallpaperCellTapped?
    @IBOutlet weak var seeMoreBtn: UIButton!
    
    var wallpaperListVM:WallpapersListVM! {
        didSet {
            self.wallpaperCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = ColorPallet.MainColor()
        wallpaperCollectionView.delegate = self
        wallpaperCollectionView.dataSource = self
        wallpaperCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension CategoryCell:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallpaperListVM.wallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryWallpaperCell", for: indexPath) as! CategoryWallpaperCell
        cell.wallImage.kf.setImage(with: URL(string: wallpaperListVM.wallpapers[indexPath.row].previewURL))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: implement device size based colums
        return CGSize(width: 158, height: 108)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    

    
}
