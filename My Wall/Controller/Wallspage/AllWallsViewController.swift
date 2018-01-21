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
import SVProgressHUD
import Appodeal
import Ambience

class AllWallsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate {

    // MARK: - Outlets
    @IBOutlet weak var wallsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var photos: [INSPhotoViewable] = {
        return []
    }()
    var useCustomOverlay = true
    
    // MARK: - Variables
    let pixabayKey = "7252395-21cd2dae7af1a432c39d2c60f"
    
    var cardsInfo:[CardLayoutInfo] = []
    var topicToSearch = ""
    var collectionID = 0
    var isCollectionDetailPage = false
    var requestUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wallsCollectionView.delegate = self
        wallsCollectionView.dataSource = self
        
        searchBar.delegate = self
        
        self.navigationItem.title = topicToSearch
        
        ViewCustomization.customiseSearchBox(searchBar: searchBar)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        var pageNumber = 1
        //        let pageNumber = 50
        let headers: HTTPHeaders = [
            "Accept-Version": "v1",
            "Authorization": "Client-ID e1fa9e9f79062543538b062e4a8d981d5a361856659bbdaf8c039a70e05a245c",
            ]
        topicToSearch = topicToSearch.replacingOccurrences(of: " ", with: "+")
        if(self.isCollectionDetailPage){
            self.requestUrl = "https://api.unsplash.com/collections/\(self.collectionID)/photos?per_page=6&page=1"
        }else{
            self.requestUrl = "https://api.unsplash.com/search/photos?query=\(topicToSearch)&per_page=6&page=\(pageNumber)"
        }
        // Requesting random images of cards
        SVProgressHUD.show(withStatus: "Getting Images...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        Alamofire.request(requestUrl,method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if(self.isCollectionDetailPage){
                    for (_,subJson):(String, JSON) in json {
                        // Do something you want
                        let imgUrl:Urls = Urls(smallImage: subJson["urls"]["small"].string!)
                        let imaged:Image = Image(url: imgUrl)
                        let cardInfo = CardLayoutInfo(cardImages: imaged,
                                                      fullQualityUrl: subJson["links"]["download"].string!,
                                                      photographerURL:subJson["user"]["links"]["html"].string!,
                                                      photographerName: subJson["user"]["name"].string!, imageUrl: subJson["links"]["html"].string!)
                    
                        self.cardsInfo.append(cardInfo)
                    }
                }else{
                    for (_,subJson):(String, JSON) in json["results"] {
                        // Do something you want
                        let imgUrl:Urls = Urls(smallImage: subJson["urls"]["small"].string!)
                        let imaged:Image = Image(url: imgUrl)
                        print("photoName: \(subJson["user"]["links"]["html"])")
                        let cardInfo = CardLayoutInfo(cardImages: imaged, fullQualityUrl: subJson["links"]["download"].string!, photographerURL: subJson["user"]["links"]["html"].string!, photographerName: subJson["user"]["name"].string!, imageUrl: subJson["links"]["html"].string!)
                        self.cardsInfo.append(cardInfo)
                    }
                }
                self.downloadCardsImages()
            case .failure(let error):
                print(error)
            }
        }
        
        wallsCollectionView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        var indexNumber = 5
        var cardindex = 5
        var collectionPageNumber = 1
        wallsCollectionView.addInfiniteScroll { (collectionView) -> Void in
            // create new index paths
            
            let defaults = UserDefaults.standard
            let hasPurchased = defaults.bool(forKey: "InappPurchaseBought")
            if (!hasPurchased){
                Appodeal.showAd(AppodealShowStyle.interstitial, rootViewController: self)
            }
            
            let photoCount = self.photos.count
            print("photoCount:\(photoCount)")
            pageNumber += 1
            collectionPageNumber += 1
            if(self.isCollectionDetailPage){
                self.requestUrl = "https://api.unsplash.com/collections/\(self.collectionID)/photos?per_page=6&page=\(collectionPageNumber)"
                print(self.requestUrl)
            }else{
                self.requestUrl = "https://api.unsplash.com/search/photos?query=\(self.topicToSearch)&per_page=6&page=\(pageNumber)"
            }
            var downloadedImgCount = 0
            // Requesting random images of cards
            Alamofire.request(self.requestUrl,method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if(self.isCollectionDetailPage){
                        for (_,subJson):(String, JSON) in json {
                            // Do something you want
                            let imgUrl:Urls = Urls(smallImage: subJson["urls"]["small"].string!)
                            let imaged:Image = Image(url: imgUrl)
                            let cardInfo = CardLayoutInfo(cardImages: imaged, fullQualityUrl: subJson["links"]["download"].string!,photographerURL:subJson["user"]["links"]["html"].string!, photographerName: subJson["user"]["name"].string!, imageUrl: subJson["links"]["html"].string!)
                            self.cardsInfo.append(cardInfo)
                        }
                    }else{
                        for (_,subJson):(String, JSON) in json["results"] {
                            // Do something you want
                            let imgUrl:Urls = Urls(smallImage: subJson["urls"]["small"].string!)
                            let imaged:Image = Image(url: imgUrl)
                            let cardInfo = CardLayoutInfo(cardImages: imaged, fullQualityUrl: subJson["links"]["download"].string!, photographerURL: subJson["user"]["links"]["html"].string!, photographerName: subJson["user"]["name"].string!, imageUrl: subJson["links"]["html"].string!)
                            self.cardsInfo.append(cardInfo)
                        }
                    }
                    print("ccount:\(self.cardsInfo.count)")
                    print("indexNumber:\(indexNumber)")
                    for (index,cardInfo) in self.cardsInfo.enumerated(){
                        if(index <= indexNumber){
                            continue
                        }
                        Alamofire.request(cardInfo.cardImages.imageUrl.small!).responseImage { response in
                            cardindex += 1
                            if let downloadedImage = response.result.value {
                                print(downloadedImage)
                                print("-------------------")
                                downloadedImgCount += 1
                                self.photos.append( INSPhoto(imageURL: URL(string: cardInfo.fullQualityUrl), thumbnailImage:downloadedImage))
                                if(downloadedImgCount == 6){
                                    downloadedImgCount = 0
                                    indexNumber = cardindex
                                    let (start, end) = (photoCount, photoCount + 6)
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
            
        }
    }
    
    
    // Download carousel images
    func downloadCardsImages(){
//        self.photos.removeAll()
        for image in self.cardsInfo{
            Alamofire.request(image.cardImages.imageUrl.small!).responseImage { response in
                if let downloadedImage = response.result.value {
                    self.photos.append( INSPhoto(imageURL: URL(string: image.fullQualityUrl), thumbnailImage:downloadedImage))
                    SVProgressHUD.dismiss()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AllWalls") as! AllWallsViewController
        vc.topicToSearch = searchBar.text!
        navigationController?.pushViewController(vc,animated: true)
    }
    
    
    public override func ambience(_ notification : Notification) {
        
        super.ambience(notification)
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        let defaults = UserDefaults.standard
        let darkMode = defaults.bool(forKey: "darkMode")
        
        print("Darkmode",currentState)
        if(currentState.rawValue == "invert"){
            defaults.set(true, forKey: "darkMode")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 43.0, green: 44.0, blue: 46.0, alpha: 1.0)
                self.navigationController?.navigationBar.isTranslucent = false
                self.navigationController?.navigationBar.barTintColor = UIColor.black
                ViewCustomization.customiseSearchBox(searchBar: self.searchBar)
                self.searchBar.barTintColor = UIColor.black
                self.searchBar.backgroundColor = UIColor.black
                self.searchBar.searchBarStyle = UISearchBarStyle.default
                UIApplication.shared.statusBarStyle = .lightContent
                
            })
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
                statusBar.backgroundColor = UIColor.black
            }
            
        }else if (currentState.rawValue == "regular" && darkMode){
            defaults.set(false, forKey: "darkMode")
            print("switched to regular mode")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.isTranslucent = true
                ViewCustomization.customiseSearchBox(searchBar: self.searchBar)
                self.searchBar.barTintColor = UIColor.clear
                self.searchBar.backgroundColor = UIColor.clear
                self.searchBar.searchBarStyle = UISearchBarStyle.default
                UIApplication.shared.statusBarStyle = .lightContent
                let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
                    statusBar.backgroundColor = UIColor.white
                }
            })
        }
    }
    
    

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
       
        CustomOverlayView.imageInfo = self.cardsInfo[indexPath.row]
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
