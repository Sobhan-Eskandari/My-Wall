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
    @IBOutlet weak var topLeftCard: Card! //done
    @IBOutlet weak var topRightCard: Card! //done
    @IBOutlet weak var topLeftBottomCard: Card! //done
    @IBOutlet weak var topRightMiddleCard: Card! //done
    @IBOutlet weak var topRightBottomCard: Card! //done
    @IBOutlet weak var middleCard: Card! //done
    @IBOutlet weak var bottomLeftCard: Card! //done
    @IBOutlet weak var bottomRightCard: Card! //done
    @IBOutlet weak var bottomLeftBottomCard: Card! //done
    @IBOutlet weak var bottomLeftMiddleCard: Card! //done
    @IBOutlet weak var bottomRightBottomCard: Card! //done
    
    // MARK: - Variables
    var items = [UIImage]() // for now fake images
    var currentPage: Int = 0
    var cardsImages:[Image] = []
    var carouselImages:[Image] = []
    var downloadedImages:[UIImage] = []
    
    
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
      
        let imageView = UIImageView()
        imageView.loadGif(name: "jeremy")
        topLeftCard.addSubview(imageView)
        
        // Do any additional setup after loading the view.
        ViewCustomization.customiseSearchBox(searchBar: searchBar)
        
        let headers: HTTPHeaders = [
            "Accept-Version": "v1",
            "Authorization": "Client-ID e1fa9e9f79062543538b062e4a8d981d5a361856659bbdaf8c039a70e05a245c",
        ]
        // Requesting random images of cards
        Alamofire.request("https://api.unsplash.com/photos/random?count=12",method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    // Do something you want
                    let imgUrl:Urls = Urls(smallImage: subJson["urls"]["small"].string!)
                    let image:Image = Image(url: imgUrl)
                    self.cardsImages.append(image)
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
        let arrayOfCards:[Card] = [topLeftCard,topRightCard,topLeftBottomCard,topRightMiddleCard,topRightBottomCard,middleCard,bottomLeftCard,bottomRightCard,bottomLeftBottomCard,bottomLeftCard,bottomLeftMiddleCard,bottomRightBottomCard]
        var imgnum = -1
        for image in self.cardsImages{
            Alamofire.request(image.imageUrl.small!).responseImage { response in
                imgnum += 1
                if let downloadedImage = response.result.value {
                    arrayOfCards[imgnum].backgroundImage = downloadedImage
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
                    print(self.downloadedImages.capacity)
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

