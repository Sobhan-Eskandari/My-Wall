//
//  AllWallsViewController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/28/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit
import INSPhotoGallery
import SwiftyJSON
import Alamofire
import AlamofireImage

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
    
    // MARK: - Variables
    let pixabayKey = "7252395-21cd2dae7af1a432c39d2c60f"
    class CardLayoutInfo {
        var cardImages:Image
        var fullQualityUrl: String
        var downloadedImage:[UIImage] = []
        
        init(cardImages:Image,fullQualityUrl: String) {
            self.cardImages = cardImages
            self.fullQualityUrl = fullQualityUrl
        }
    }
    var cardsInfo:[CardLayoutInfo] = []
    var topicToSearch = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wallsCollectionView.delegate = self
        wallsCollectionView.dataSource = self
        
        ViewCustomization.customiseSearchBox(searchBar: searchBar)
        
        var pageNumber = Int(arc4random_uniform(60))
        //        let pageNumber = 50
        let headers: HTTPHeaders = [
            "Accept-Version": "v1",
            "Authorization": "Client-ID e1fa9e9f79062543538b062e4a8d981d5a361856659bbdaf8c039a70e05a245c",
            ]
        topicToSearch = topicToSearch.replacingOccurrences(of: " ", with: "+")
        let requestUrl = "https://api.unsplash.com/search/photos?query=\(topicToSearch)&per_page=6&page=1"
        // Requesting random images of cards
        
        Alamofire.request(requestUrl,method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json["results"] {
                    // Do something you want
                    let imgUrl:Urls = Urls(smallImage: subJson["urls"]["small"].string!)
                    let imaged:Image = Image(url: imgUrl)
                    let cardInfo = CardLayoutInfo(cardImages: imaged, fullQualityUrl: subJson["urls"]["regular"].string!)
                    self.cardsInfo.append(cardInfo)
                }
                self.downloadCardsImages()
            case .failure(let error):
                print(error)
            }
        }
        
        wallsCollectionView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        var indexNumber = 3
        wallsCollectionView.addInfiniteScroll { (collectionView) -> Void in
            // create new index paths
            
        
            indexNumber += 2
            let photoCount = self.photos.count
            pageNumber += 1
            let requestUrl = "https://api.unsplash.com/search/photos?query=\(self.topicToSearch)?per_page=2&page=\(pageNumber)"
            var downloadedImgCount = 0
            // Requesting random images of cards
            Alamofire.request(requestUrl,method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for (_,subJson):(String, JSON) in json {
                        // Do something you want
                        let imgUrl:Urls = Urls(smallImage: subJson["urls"]["small"].string!)
                        let imaged:Image = Image(url: imgUrl)
                        let cardInfo = CardLayoutInfo(cardImages: imaged, fullQualityUrl: subJson["urls"]["regular"].string!)
                        self.cardsInfo.append(cardInfo)
                    }
                    print(self.cardsInfo)
                    for (index,cardInfo) in self.cardsInfo.enumerated(){
                        if(index <= indexNumber){
                            continue
                        }
                        print("index:\(index)->\(cardInfo.cardImages)")
                        Alamofire.request(cardInfo.cardImages.imageUrl.small!).responseImage { response in
                            if let downloadedImage = response.result.value {
                                print(downloadedImage)
                                print("-------------------")
                                downloadedImgCount += 1
                                self.photos.append( INSPhoto(imageURL: URL(string: cardInfo.fullQualityUrl), thumbnailImage:downloadedImage))
                                if(downloadedImgCount == 2){
                                    downloadedImgCount = 0
                                    let (start, end) = (photoCount, photoCount + 2)
                                    let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                                    
                                    // update collection view
                                    self.wallsCollectionView?.performBatchUpdates({ () -> Void in
                                        self.wallsCollectionView?.insertItems(at: indexPaths)
                                    }, completion: { (finished) -> Void in});
                                    
                                    collectionView.finishInfiniteScroll()
                                }
                            }
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            
            
//            let photoCount = self.photos.count
////            self.photos.append(INSPhoto(image: UIImage(named: "wall4")!, thumbnailImage: UIImage(named: "wall1")!))
////            self.photos.append(INSPhoto(image: UIImage(named: "wall3")!, thumbnailImage: UIImage(named: "wall1")!))
////
//
//            let (start, end) = (photoCount, photoCount + 2)
//            let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
//
//            // update collection view
//            self.wallsCollectionView?.performBatchUpdates({ () -> Void in
//                self.wallsCollectionView?.insertItems(at: indexPaths)
//            }, completion: { (finished) -> Void in
//
//            });
//
//            collectionView.finishInfiniteScroll()
        }
    }
    
    
    // Download carousel images
    func downloadCardsImages(){
        self.photos.removeAll()
        for image in self.cardsInfo{
            Alamofire.request(image.cardImages.imageUrl.small!).responseImage { response in
                if let downloadedImage = response.result.value {
                    self.photos.append( INSPhoto(imageURL: URL(string: image.fullQualityUrl), thumbnailImage:downloadedImage))
                    self.wallsCollectionView.reloadData()
                }
            }
        }
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
        cell.populateWithPhoto(self.photos[(indexPath as NSIndexPath).row])
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
