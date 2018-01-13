//
//  HomeViewController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/23/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import Cards
import SwiftyJSON
import Alamofire
import AlamofireImage
import SwiftGifOrigin

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topLeftCard: CardGroup! //done
    @IBOutlet weak var topRightCard: CardGroup! //done
    @IBOutlet weak var topLeftBottomCard: CardGroup! //done
    @IBOutlet weak var topRightMiddleCard: CardGroup! //done
    @IBOutlet weak var topRightBottomCard: CardGroup! //done
    @IBOutlet weak var middleCard: CardGroup! //done
    @IBOutlet weak var bottomLeftCard: CardGroup! //done
    @IBOutlet weak var bottomRightCard: CardGroup! //done
    @IBOutlet weak var bottomLeftBottomCard: CardGroup! //done
    @IBOutlet weak var bottomLeftMiddleCard: CardGroup! //done
    @IBOutlet weak var bottomRightBottomCard: CardGroup! //done
    
    // MARK: - Variables
    struct CardLayoutInfo {
        var cardImage: Image
        var cardTitle: String
    }
    var cardsInfo:[CardLayoutInfo] = []
    var items = [UIImage]() // for now fake images
    var currentPage: Int = 0
    var cardsImages:[Image] = []
    var cardsImagesTags:[String] = []
    var carouselImages:[Image] = []
    var downloadedImages:[UIImage] = []
    let pixabayKey = "7252395-21cd2dae7af1a432c39d2c60f"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadedImages.append(UIImage(named: "wall1")!) // fake images
        downloadedImages.append(UIImage(named: "wall2")!) // fake images
        downloadedImages.append(UIImage(named: "wall3")!) // fake images
        self.setupLayout()
        
        // MARK: - Setting delegates of cards
        topLeftCard.delegate = self
        topLeftCard.hasParallax = true
        topRightCard.delegate = self
        topRightCard.hasParallax = true
        topLeftBottomCard.delegate = self
        topLeftBottomCard.hasParallax = true
        topRightMiddleCard.delegate = self
        topRightMiddleCard.hasParallax = true
        topRightBottomCard.delegate = self
        topRightBottomCard.hasParallax = true
        middleCard.delegate = self
        middleCard.hasParallax = true
        bottomLeftCard.delegate = self
        bottomLeftCard.hasParallax = true
        bottomRightCard.delegate = self
        bottomRightCard.hasParallax = true
        bottomLeftBottomCard.delegate = self
        bottomLeftBottomCard.hasParallax = true
        bottomLeftCard.delegate = self
        bottomLeftCard.hasParallax = true
        bottomLeftMiddleCard.delegate = self
        bottomLeftMiddleCard.hasParallax = true
        bottomRightBottomCard.delegate = self
        bottomRightBottomCard.hasParallax = true
      
        
        // Do any additional setup after loading the view.
        ViewCustomization.customiseSearchBox(searchBar: searchBar)
        
        let headers: HTTPHeaders = [
            "Accept-Version": "v1",
            "Authorization": "Client-ID e1fa9e9f79062543538b062e4a8d981d5a361856659bbdaf8c039a70e05a245c",
        ]
        let pageNumber = Int(arc4random_uniform(39))
        print(pageNumber)
        let requestUrl = "https://pixabay.com/api/?key=\(pixabayKey)&per_page=12&page=\(pageNumber)&editors_choice=true&safesearch=true"
        // Requesting random images of cards
        Alamofire.request(requestUrl,method: .get,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    // Do something you want
                    for (_,innerJson):(String, JSON) in subJson {
                        let imgUrl:Urls = Urls(smallImage: innerJson["webformatURL"].string!)
                        var cardTag:String = innerJson["tags"].string!
                        cardTag = cardTag.components(separatedBy: ",")[0].capitalizingFirstLetter()
                        print(cardTag)
                        let image:Image = Image(url: imgUrl)
                        let cardInfo = CardLayoutInfo(cardImage: image, cardTitle: cardTag)
                        self.cardsInfo.append(cardInfo)
                    }
                }
                self.downloadCardsImages()
            case .failure(let error):
                print(error)
            }
        }
        // Requesting random images of carousel
        Alamofire.request("https://api.unsplash.com/photos/random?count=3",method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    // Do something you want
                    let imgUrl:Urls = Urls(regularImage: subJson["urls"]["regular"].string!)
                    let image:Image = Image(url: imgUrl)
                    self.carouselImages.append(image)
                }
                self.downloadCarouselImage()
            case .failure(let error):
                print(error)
            }
        }
    }

    // Download cards images
    func downloadCardsImages() {
        let arrayOfCards:[CardGroup] = [topLeftCard,topRightCard,topLeftBottomCard,topRightMiddleCard,topRightBottomCard,middleCard,bottomLeftCard,bottomRightCard,bottomLeftBottomCard,bottomLeftCard,bottomLeftMiddleCard,bottomRightBottomCard]
        var imgnum = -1
        for cardInfo in self.cardsInfo{
            print(cardInfo)
            Alamofire.request(cardInfo.cardImage.imageUrl.small!).responseImage { response in
                imgnum += 1
                if let downloadedImage = response.result.value {
                    arrayOfCards[imgnum].backgroundImage = downloadedImage
                    arrayOfCards[imgnum].title = cardInfo.cardTitle
                }
            }
        }
    }
    
    // Download carousel images
    func downloadCarouselImage(){
        self.downloadedImages.removeAll()
        for image in self.carouselImages{
            Alamofire.request(image.imageUrl.regular!).responseImage { response in
                if let downloadedImage = response.result.value {
                    self.downloadedImages.append(downloadedImage)
                    if (self.downloadedImages.capacity == 4){
                        self.collectionView.reloadData()
                    }
                }
                
            }
        }
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

extension HomeViewController {
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCarouselCell.identifier, for: indexPath) as! HomeCarouselCell
        let image = downloadedImages[indexPath.row]
        cell.image.image = image
        cell.image.clipsToBounds = true
        cell.image.layer.cornerRadius = 10
        cell.image.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: \(indexPath.row)")
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize.zero
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            size = layout.itemSize;
            size.width = collectionView.bounds.width
        }
        
        return size
    }
    
    
    var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
}


extension HomeViewController: CardDelegate {

    func cardDidTapInside(card: Card) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AllWalls") as! AllWallsViewController
        navigationController?.pushViewController(vc,animated: true)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

