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
import Ambience


class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate,UIScrollViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    var carouselImages:[CardLayoutInfo] = []
    var downloadedImages:[UIImage] = []
    let pixabayKey = "7252395-21cd2dae7af1a432c39d2c60f"
    weak var timer: Timer?
    var timerDispatchSourceTimer : DispatchSourceTimer?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadedImages.append(UIImage(named: "nick-de-partee-97063")!) // fake images
        downloadedImages.append(UIImage(named: "nick-de-partee-97063")!) // fake images
        downloadedImages.append(UIImage(named: "nick-de-partee-97063")!) // fake images
        self.setupLayout()
        
        self.scrollView.delegate = self
        
        collectionView.showsHorizontalScrollIndicator = false
        searchBar.delegate = self
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
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let pageNumber = Int(arc4random_uniform(50))
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
        Alamofire.request("https://pixabay.com/api/?key=\(pixabayKey)&per_page=3&page=\(pageNumber)&editors_choice=true&safesearch=true",method: .get,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    // Do something you want
                    for (_,innerJson):(String, JSON) in subJson {
                        let imgUrl:Urls = Urls(regularImage: innerJson["webformatURL"].string!)
                        var cardTag:String = innerJson["tags"].string!
                        cardTag = cardTag.components(separatedBy: ",")[0].capitalizingFirstLetter()
                        let image:Image = Image(url: imgUrl)
                        let cardInfo = CardLayoutInfo(cardImage: image, cardTitle: cardTag)
                        self.carouselImages.append(cardInfo)
                    }
                }
                self.downloadCarouselImage()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        self.searchBar.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    // Download cards images
    func downloadCardsImages() {
        let arrayOfCards:[CardGroup] = [topLeftCard,topRightCard,topLeftBottomCard,topRightMiddleCard,topRightBottomCard,middleCard,bottomLeftCard,bottomRightCard,bottomLeftBottomCard,bottomLeftCard,bottomLeftMiddleCard,bottomRightBottomCard]
        var imgnum = -1
        for cardInfo in self.cardsInfo{
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
            Alamofire.request(image.cardImage.imageUrl.regular!).responseImage { response in
                if let downloadedImage = response.result.value {
                    self.downloadedImages.append(downloadedImage)
                    if (self.downloadedImages.count == 3){
                        print("deeee")
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

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AllWalls") as! AllWallsViewController
        vc.topicToSearch = searchBar.text!
        navigationController?.pushViewController(vc,animated: true)
    }
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AllWalls") as! AllWallsViewController
        vc.topicToSearch = self.carouselImages[indexPath.row].cardTitle
        navigationController?.pushViewController(vc,animated: true)
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
    
    
    override func ambience(_ notification : Notification) {
    
        super.ambience(notification)
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        let defaults = UserDefaults.standard
        let darkMode = defaults.bool(forKey: "darkMode")
        
        print("Darkmode",currentState)
        if(currentState.rawValue == "invert"){
            defaults.set(true, forKey: "darkMode")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 43.0, green: 44.0, blue: 46.0, alpha: 1.0)
//                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.isTranslucent = false
                self.navigationController?.navigationBar.barTintColor = UIColor.black
                
                self.topLeftCard.shadowColor = UIColor.clear
                self.topRightCard.shadowColor = UIColor.clear
                self.topLeftBottomCard.shadowColor = UIColor.clear
                self.topRightBottomCard.shadowColor = UIColor.clear
                self.topRightMiddleCard.shadowColor = UIColor.clear
                self.middleCard.shadowColor = UIColor.clear
                self.bottomLeftCard.shadowColor = UIColor.clear
                self.bottomRightCard.shadowColor = UIColor.clear
                self.bottomLeftBottomCard.shadowColor = UIColor.clear
                self.bottomRightBottomCard.shadowColor = UIColor.clear
                self.bottomLeftMiddleCard.shadowColor = UIColor.clear
                print("its fuckingggg hereeeeeee")
                ViewCustomization.customiseSearchBox(searchBar: self.searchBar)
                self.searchBar.barTintColor = UIColor.black
                self.searchBar.backgroundColor = UIColor.black
//                self.searchBar.barStyle = UIBarStyle.blackTranslucent
                self.searchBar.searchBarStyle = UISearchBarStyle.minimal
                UIApplication.shared.statusBarStyle = .lightContent
                let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
                    statusBar.backgroundColor = UIColor.black
                }
            })
            
        }else if (currentState.rawValue == "regular" && darkMode){
            defaults.set(false, forKey: "darkMode")
            print("switched to regular mode")
            let shadowColor = UIColor(red: 0.715315, green: 0.765404, blue: 0.824527, alpha: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.topLeftCard.shadowColor = shadowColor
                self.topRightCard.shadowColor = shadowColor
                self.topLeftBottomCard.shadowColor = shadowColor
                self.topRightBottomCard.shadowColor = shadowColor
                self.topRightMiddleCard.shadowColor = shadowColor
                self.middleCard.shadowColor = shadowColor
                self.bottomLeftCard.shadowColor = shadowColor
                self.bottomRightCard.shadowColor = shadowColor
                self.bottomLeftBottomCard.shadowColor = shadowColor
                self.bottomRightBottomCard.shadowColor = shadowColor
                self.bottomLeftMiddleCard.shadowColor = shadowColor
                ViewCustomization.customiseSearchBox(searchBar: self.searchBar)
                self.searchBar.barTintColor = UIColor.clear
                self.searchBar.backgroundColor = UIColor.clear
                self.searchBar.searchBarStyle = UISearchBarStyle.default
                UIApplication.shared.statusBarStyle = .lightContent
                
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.isTranslucent = true
                
                let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
                    statusBar.backgroundColor = UIColor.white
                }
            })
        }
    }

}


extension HomeViewController: CardDelegate {

    func cardDidTapInside(card: Card) {
        let cardgroup = card as! CardGroup
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AllWalls") as! AllWallsViewController
        vc.topicToSearch = cardgroup.title
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

