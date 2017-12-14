//
//  AllWallsViewController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/28/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit
import INSPhotoGallery

class AllWallsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var wallsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var photos: [INSPhotoViewable] = {
        return [
            INSPhoto(imageURL: URL(string: "https://www.nature.org/cs/groups/webcontent/@photopublic/documents/media/east-kalimantan-361x248.jpg"), thumbnailImage: UIImage(named: "https://www.nature.org/cs/groups/webcontent/@photopublic/documents/media/east-kalimantan-361x248.jpg")),
            INSPhoto(imageURL: URL(string: "https://lh6.ggpht.com/2CvQXZEebo7M_XWJ0C5NVBxIsGgkHIz8RaeUq8wgpjM6bHt3-BpiJxoJieltDNsqJg=h900"), thumbnailImage: UIImage(named: "wall1")!),
            INSPhoto(image: UIImage(named: "wall4")!, thumbnailImage: UIImage(named: "wall1")!),
            INSPhoto(imageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg"), thumbnailImageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg")),
            INSPhoto(imageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg"), thumbnailImageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg")),
            INSPhoto(imageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg"), thumbnailImageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg"))
            
        ]
    }()
    var useCustomOverlay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wallsCollectionView.delegate = self
        wallsCollectionView.dataSource = self
        
        ViewCustomization.customiseSearchBox(searchBar: searchBar)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AllWallsViewController:UICollectionViewDelegateFlowLayout {
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let theWidth = (view.frame.width - 10)/2    // it will generate 2 column
        let theHeight = (view.frame.height - (10*2))/3   // it will generate 3 Row
        return CGSize(width: theWidth ,height: theHeight)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallCell.identifier, for: indexPath) as! WallCell
//        cell.layer.backgroundColor = UIColor.clear.cgColor
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "wallDetail") as! WallDetailController
//        navigationController?.pushViewController(vc,animated: true)
//    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallCell.identifier, for: indexPath) as! WallCell
        cell.populateWithPhoto(photos[(indexPath as NSIndexPath).row])
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WallCell
        let currentPhoto = photos[(indexPath as NSIndexPath).row]
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
        if useCustomOverlay {
            galleryPreview.overlayView = CustomOverlayView(frame: CGRect.zero)
        }
        
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? WallCell
            }
            return nil
        }
        present(galleryPreview, animated: true, completion: nil)
    }
    

}
