//
//  CollectionsViewController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 12/1/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import SVProgressHUD
import Appodeal
import Ambience

class CollectionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionsTableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    let pixabayKey = "7252395-21cd2dae7af1a432c39d2c60f"
    class CardLayoutInfo {
        let collectionId:Int
        var cardImages:[Image]
        var cardTitle: String
        var downloadedImages:[UIImage] = []
        
        init(cardImages:[Image],cardTitle: String,collectionID:Int) {
            self.cardImages = cardImages
            self.cardTitle = cardTitle
            self.collectionId = collectionID
        }
    }
    var cell:CollectionTableCell? = nil
    var cardsInfo:[CardLayoutInfo] = []
    var downloadingImages:[UIImage] = []
    var indexPaths : [IndexPath] = []
    var isSearchingCollection = false
    var searchQuery = "Collections"
    var requestUrl = ""
    var collectionTitles:[String] = []
    var request = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionsTableview.delegate = self
        collectionsTableview.dataSource = self
        collectionsTableview.rowHeight = 200.0
        
        searchBar.delegate = self
        collectionsTableview.delegate = self
        self.navigationItem.title = self.searchQuery
        SVProgressHUD.show(withStatus: "Getting Images...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        var pageNumber = Int(arc4random_uniform(120))
        if(isSearchingCollection){
            self.request = "https://pixabay.com/api/?key=\(pixabayKey)&per_page=3&page=\(pageNumber)&safesearch=true&q=\(searchQuery)"
        }else{
            self.request = "https://pixabay.com/api/?key=\(pixabayKey)&per_page=3&page=\(pageNumber)&safesearch=true"
        }
        
        // Requesting random images of cards
        Alamofire.request(self.request,method: .get,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    // Do something you want
                    for (_,innerJson):(String, JSON) in subJson {
                        var cardTag:String = innerJson["tags"].string!
                        cardTag = cardTag.components(separatedBy: ",")[0].capitalizingFirstLetter()
                        self.collectionTitles.append(cardTag)
                    }
                }
                self.downloadCollectionImages()
//                self.downloadCardsImages()
            case .failure(let error):
                print(error)
            }
        }
        
        
        ViewCustomization.customiseSearchBox(searchBar: searchBar)
        
        collectionsTableview.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        var indexNumber = 0
        var searchPageNumber = 0
        collectionsTableview.addInfiniteScroll { (tableView) -> Void in
            // update table view
            
            let defaults = UserDefaults.standard
            let hasPurchased = defaults.bool(forKey: "InappPurchaseBought")
            if (!hasPurchased){
                Appodeal.showAd(AppodealShowStyle.interstitial, rootViewController: self)
            }
            
            indexNumber += 2
            let collCount = self.cardsInfo.count
            pageNumber += 1
            searchPageNumber += 1
            let requestAddress = "https://pixabay.com/api/?key=\(self.pixabayKey)&per_page=3&page=\(pageNumber)&safesearch=true"
          
            // Requesting random images of cards
            
            self.collectionTitles.removeAll()
            Alamofire.request(requestAddress,method: .get,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for (_,subJson):(String, JSON) in json {
                        // Do something you want
                        for (_,innerJson):(String, JSON) in subJson {
                            var cardTag:String = innerJson["tags"].string!
                            cardTag = cardTag.components(separatedBy: ",")[0].capitalizingFirstLetter()
                            self.collectionTitles.append(cardTag)
                        }
                    }
                    
                    let pageNumber = Int(arc4random_uniform(39))
                    var arrayOfNewImages:[Image] = []
                    self.collectionTitles.remove(at: 0)
                    var cardinfocount = 3
                    for cardtitle in self.collectionTitles {
                        let titeToSearch = cardtitle.replacingOccurrences(of: " ", with: "+")
                        print(cardtitle)
                        let requestUrl = "https://pixabay.com/api/?key=\(self.pixabayKey)&per_page=3&q=\(titeToSearch)&page=\(pageNumber)&safesearch=true"
                        Alamofire.request(requestUrl,method: .get,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let json = JSON(value)
                                for (index,subJson):(String, JSON) in json["hits"] {
                                    // Do something you want
//                                    print(subJson)
                                    let imgUrl:Urls = Urls(smallImage: subJson["webformatURL"].string!)
                                    let imaged:Image = Image(url: imgUrl)
                                    arrayOfNewImages.append(imaged)
                                    if (Int(index) == 2){
                                        let cardInfo = CardLayoutInfo(cardImages: arrayOfNewImages, cardTitle: cardtitle, collectionID: 0)
                                        self.cardsInfo.append(cardInfo)
                                        cardinfocount += 1
                                        arrayOfNewImages.removeAll()
                                        print("cardInfo-Count",self.cardsInfo.count)
                                        if(self.cardsInfo.count % 2 != 0){
                                            var cardnum = 0
                                            var cardindex = indexNumber+1
                                            for (index,cardInfo) in self.cardsInfo.enumerated(){
                                                if(index <= indexNumber){
                                                    print("index:\(index)-indexnumner:\(indexNumber)")
                                                    continue
                                                }
                                                for cardImageAddress in cardInfo.cardImages{
                                                    Alamofire.request(cardImageAddress.imageUrl.small!).responseImage { response in
                                                        cardnum += 1
                                                        print(cardImageAddress.imageUrl.small!)
                                                        if let downloadedImage = response.result.value {
                                                            print(cardnum)
                                                            self.downloadingImages.append(downloadedImage)
                                                            if(self.downloadingImages.count == 3){
                                                                self.cardsInfo[cardindex].downloadedImages = self.downloadingImages
                                                                if(cardnum % 3 == 0){
                                                                    cardindex += 1
                                                                }
                                                                self.downloadingImages.removeAll()
                                                            }
                                                            if (self.cardsInfo[indexNumber+1].downloadedImages.count == 3 && self.cardsInfo[indexNumber+2].downloadedImages.count == 3){
                                                                print("counter:\(self.cardsInfo[indexNumber+1].downloadedImages.count == 3)||\(self.cardsInfo[indexNumber+2].downloadedImages.count == 3)")
                                                                let (start, end) = (collCount, collCount + 2)
                                                                self.indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                                                                
                                                                self.collectionsTableview.beginUpdates()
                                                                self.collectionsTableview.insertRows(at: self.indexPaths, with: .automatic)
                                                                self.collectionsTableview.endUpdates()
                                                                
                                                                tableView.finishInfiniteScroll()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
  
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }

    fileprivate func performFetch(_ completionHandler: (() -> Void)?) {
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
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
    
    func downloadCollectionImages() {
        let pageNumber = Int(arc4random_uniform(39))
        var arrayOfNewImages:[Image] = []
        for cardtitle in self.collectionTitles {
            let titeToSearch = cardtitle.replacingOccurrences(of: " ", with: "+")
            let requestUrl = "https://pixabay.com/api/?key=\(pixabayKey)&per_page=3&q=\(titeToSearch)&page=\(pageNumber)&safesearch=true"
            Alamofire.request(requestUrl,method: .get,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for (index,subJson):(String, JSON) in json["hits"] {
                        // Do something you want
                        
                        let imgUrl:Urls = Urls(smallImage: subJson["webformatURL"].string!)
                        let imaged:Image = Image(url: imgUrl)
                        arrayOfNewImages.append(imaged)
                        if (Int(index) == 2){
                            let cardInfo = CardLayoutInfo(cardImages: arrayOfNewImages, cardTitle: cardtitle, collectionID: 0)
                            self.cardsInfo.append(cardInfo)
                            arrayOfNewImages.removeAll()
                            if(self.cardsInfo.count == 3){
                                self.downloadCardsImages()
                            }
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
       
    }
    
    // Download cards images
    func downloadCardsImages() {
        print("salaaaaammm")
        var cardnum = 0
        var cardindex = 0
        for (_,cardInfo) in self.cardsInfo.enumerated(){
            for cardImageAddress in cardInfo.cardImages{
                Alamofire.request(cardImageAddress.imageUrl.small!).responseImage { response in
                    cardnum += 1
                    if let downloadedImage = response.result.value {
                        self.downloadingImages.append(downloadedImage)
                        if(self.downloadingImages.count == 3){
                            self.cardsInfo[cardindex].downloadedImages = self.downloadingImages
                            if(cardnum % 3 == 0){
                                cardindex += 1
                            }
                            self.downloadingImages.removeAll()
                        }
                        print(self.cardsInfo[0].downloadedImages.count,self.cardsInfo[1].downloadedImages.count,self.cardsInfo[2].downloadedImages.count)
                        if (self.cardsInfo[0].downloadedImages.count == 3 && self.cardsInfo[1].downloadedImages.count == 3 && self.cardsInfo[2].downloadedImages.count == 3){
                            self.collectionsTableview.reloadData()
                            SVProgressHUD.dismiss()
                        }
                    }
                }
                
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CollectionPage") as! CollectionsViewController
        vc.searchQuery = searchBar.text!
        vc.isSearchingCollection = true
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
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 43.0, green: 44.0, blue: 46.0, alpha: 1.0)
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor.black
            ViewCustomization.customiseSearchBox(searchBar: searchBar)
            searchBar.barStyle = UIBarStyle.blackTranslucent
            searchBar.searchBarStyle = UISearchBarStyle.minimal
            ViewCustomization.customiseSearchBox(searchBar: searchBar)
            UIApplication.shared.statusBarStyle = .lightContent
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
                statusBar.backgroundColor = UIColor.black
            }
            cell?.collectionBc.layer.shadowColor = UIColor.clear.cgColor
        }else if (currentState.rawValue == "regular" && darkMode){
            defaults.set(false, forKey: "darkMode")
            print("switched to regular mode")
            navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
            ViewCustomization.customiseSearchBox(searchBar: searchBar)
            searchBar.barStyle = UIBarStyle.blackTranslucent
            searchBar.searchBarStyle = UISearchBarStyle.default
            ViewCustomization.customiseSearchBox(searchBar: searchBar)
            UIApplication.shared.statusBarStyle = .lightContent
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
                statusBar.backgroundColor = UIColor.white
            }
        }
    }

    
}


extension CollectionsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableCell.identifier, for: indexPath) as? CollectionTableCell
        let cardInfo = self.cardsInfo[indexPath.row]
        print(indexPath.row)
        cell?.mainImage.image = cardInfo.downloadedImages[0]
        cell?.topRightImage.image = cardInfo.downloadedImages[1]
        cell?.bottomRightImage.image = cardInfo.downloadedImages[2]
        cell?.mainImage.contentMode = .scaleAspectFill
        cell?.bottomRightImage.contentMode = .scaleAspectFill
        cell?.topRightImage.contentMode = .scaleAspectFill
        cell?.featuredTitle.text = cardInfo.cardTitle
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cardInfo = self.cardsInfo[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AllWalls") as! AllWallsViewController
        vc.isCollectionDetailPage = true
        vc.collectionID = cardInfo.collectionId
        vc.topicToSearch = cardInfo.cardTitle
        navigationController?.pushViewController(vc,animated: true)
    }
}

