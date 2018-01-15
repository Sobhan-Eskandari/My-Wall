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

class CollectionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionsTableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    
    // MARK: - Variables
    let pixabayKey = "7252395-21cd2dae7af1a432c39d2c60f"
    class CardLayoutInfo {
        var cardImages:[Image]
        var cardTitle: String
        var downloadedImages:[UIImage] = []
        
        init(cardImages:[Image],cardTitle: String) {
            self.cardImages = cardImages
            self.cardTitle = cardTitle
        }
    }
    var cardsInfo:[CardLayoutInfo] = []
    var downloadingImages:[UIImage] = []
    var indexPaths : [IndexPath] = []
    
    
    var collections = ["hi","helloe","buy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionsTableview.delegate = self
        collectionsTableview.dataSource = self
        collectionsTableview.rowHeight = 200.0
        
        var pageNumber = Int(arc4random_uniform(39))
//        let pageNumber = 50
        let headers: HTTPHeaders = [
            "Accept-Version": "v1",
            "Authorization": "Client-ID e1fa9e9f79062543538b062e4a8d981d5a361856659bbdaf8c039a70e05a245c",
            ]
        let requestUrl = "https://api.unsplash.com/collections/featured?per_page=3&page=\(pageNumber)"
        var arrayOfCollectionImages:[Image] = []
        // Requesting random images of cards
        Alamofire.request(requestUrl,method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    // Do something you want
                    for (index,innerJson):(String, JSON) in subJson["preview_photos"] {
//                        print("index:\(index) -> \(innerJson["urls"]["small"])")
//                        print("------\(subJson["title"])")
                        let imgUrl:Urls = Urls(smallImage: innerJson["urls"]["small"].string!)
                        let image:Image = Image(url: imgUrl)
                        arrayOfCollectionImages.append(image)
                        if(Int(index) == 3){
                            let cardInfo = CardLayoutInfo(cardImages: arrayOfCollectionImages, cardTitle: subJson["title"].string!)
                            self.cardsInfo.append(cardInfo)
                            arrayOfCollectionImages.removeAll()
                        }
                    }
                }
                self.downloadCardsImages()
            case .failure(let error):
                print(error)
            }
        }
        
        
        ViewCustomization.customiseSearchBox(searchBar: searchBar)
        
        collectionsTableview.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        var indexNumber = 0
        collectionsTableview.addInfiniteScroll { (tableView) -> Void in
            // update table view
            
            indexNumber += 2
            let collCount = self.cardsInfo.count
            pageNumber += 1
            let requestUrl = "https://api.unsplash.com/collections/featured?per_page=2&page=\(pageNumber)"
            var arrayOfNewImages:[Image] = []
            // Requesting random images of cards
            Alamofire.request(requestUrl,method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for (_,subJson):(String, JSON) in json {
                        // Do something you want
                        for (index,innerJson):(String, JSON) in subJson["preview_photos"] {
                            let imgUrl:Urls = Urls(smallImage: innerJson["urls"]["small"].string!)
                            let image:Image = Image(url: imgUrl)
                            arrayOfNewImages.append(image)
                            if(Int(index) == 3){
                                let cardInfo = CardLayoutInfo(cardImages: arrayOfNewImages, cardTitle: subJson["title"].string!)
                                self.cardsInfo.append(cardInfo)
//                                print("->\(cardInfo.cardImages)")
                                arrayOfNewImages.removeAll()
                            }
                        }
                    }
                    
                    
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
                                    if(self.downloadingImages.count == 4){
                                        self.cardsInfo[cardindex].downloadedImages = self.downloadingImages
                                        if(cardnum % 4 == 0){
                                            cardindex += 1
                                        }
                                        self.downloadingImages.removeAll()
                                    }
                                    if (self.cardsInfo[indexNumber+1].downloadedImages.count == 4 && self.cardsInfo[indexNumber+2].downloadedImages.count == 4){
                                        print("counter:\(self.cardsInfo[indexNumber+1].downloadedImages.count == 4)||\(self.cardsInfo[indexNumber+2].downloadedImages.count == 4)")
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
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    fileprivate func performFetch(_ completionHandler: (() -> Void)?) {
       
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
    
    // Download cards images
    func downloadCardsImages() {
        var cardnum = 0
        var cardindex = 0
        for (_,cardInfo) in self.cardsInfo.enumerated(){
            for cardImageAddress in cardInfo.cardImages{
                Alamofire.request(cardImageAddress.imageUrl.small!).responseImage { response in
                    cardnum += 1
                    if let downloadedImage = response.result.value {
                        self.downloadingImages.append(downloadedImage)
                        if(self.downloadingImages.count == 4){
                            self.cardsInfo[cardindex].downloadedImages = self.downloadingImages
                            if(cardnum % 4 == 0){
                                cardindex += 1
                            }
                            self.downloadingImages.removeAll()
                        }
                        if (self.cardsInfo[0].downloadedImages.count == 4 && self.cardsInfo[1].downloadedImages.count == 4 && self.cardsInfo[2].downloadedImages.count == 4){
                            self.collectionsTableview.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    // Download cards images
    func downloadNewImages(indexNumber:Int) {
        var cardnum = 0
        var cardindex = 0
        for (index,cardInfo) in self.cardsInfo.enumerated(){
            if(index<indexNumber){
                continue
            }
            for cardImageAddress in cardInfo.cardImages{
                Alamofire.request(cardImageAddress.imageUrl.small!).responseImage { response in
                    cardnum += 1
                    if let downloadedImage = response.result.value {
                        print(cardnum)
                        self.downloadingImages.append(downloadedImage)
                        if(self.downloadingImages.count == 2){
                            self.cardsInfo[cardindex].downloadedImages = self.downloadingImages
                            if(cardnum % 4 == 0){
                                cardindex += 1
                            }
                            print("index:\(index) -> \(self.cardsInfo[index].downloadedImages)")
                            print("counter:\(self.cardsInfo[0].downloadedImages.count == 4)||\(self.cardsInfo[1].downloadedImages.count == 4)||\(self.cardsInfo[2].downloadedImages.count == 4)||")
                            self.downloadingImages.removeAll()
                        }
                        if (self.cardsInfo[0].downloadedImages.count == 4 && self.cardsInfo[1].downloadedImages.count == 4 && self.cardsInfo[2].downloadedImages.count == 4){
                           
                        }
                    }
                }
                
            }
        }
    }
}

//cardCounter += 1
//if let downloadedImage = response.result.value {
//    downloadingImagesCounter += 1
//    downloadingImages.append(downloadedImage)
//    if (downloadingImagesCounter % 2 == 0){
//
//    }
//    if (downloadingImagesCounter == 11){
//        self.collectionsTableview.reloadData()
//    }
//}

extension CollectionsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableCell.identifier, for: indexPath) as! CollectionTableCell
        let cardInfo = self.cardsInfo[indexPath.row]
        print(indexPath.row)
        cell.mainImage.image = cardInfo.downloadedImages[0]
        cell.topRightImage.image = cardInfo.downloadedImages[1]
        cell.bottomRightImage.image = cardInfo.downloadedImages[2]
        cell.mainImage.contentMode = .scaleAspectFill
        cell.bottomRightImage.contentMode = .scaleAspectFill
        cell.topRightImage.contentMode = .scaleAspectFill
        cell.featuredTitle.text = cardInfo.cardTitle
        return cell
    }
}
