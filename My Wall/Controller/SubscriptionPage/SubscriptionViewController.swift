//
//  SubscriptionViewController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/29/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import Cards

class SubscriptionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    enum SubscriptionPlans {
        case Monthly
        case threeMonths
        case sixMonths
        case yearly
        case forever
    }
    var subscrptionPlans = [SubscriptionPlans.Monthly,SubscriptionPlans.threeMonths,SubscriptionPlans.sixMonths,SubscriptionPlans.yearly,SubscriptionPlans.forever] // for now fake images
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        
        
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

extension SubscriptionViewController {
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscrptionPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanCell.identifier, for: indexPath) as! PlanCell
        setGradientGreenBlue(uiView: cell.gradientBc, plan: subscrptionPlans[indexPath.row])
        cell.gradientBc.clipsToBounds = true
        cell.gradientBc.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: \(indexPath.row)")
    }
    
    
    // Sets gradient to a uiview
    func setGradientGreenBlue(uiView: UIView,plan: SubscriptionPlans) {
        
        var colorTop =  UIColor(red: 15.0/255.0, green: 118.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor
        var colorBottom = UIColor(red: 84.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 1.0).cgColor
        
        switch plan {
        case .Monthly:
            colorTop =  UIColor(red: 80.0/255.0, green: 49.0/255.0, blue: 158.0/255.0, alpha: 1.0).cgColor
            colorBottom = UIColor(red: 27.0/255.0, green: 219.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor
        case .threeMonths:
            colorTop =  UIColor(red: 69.0/255.0, green: 233.0/255.0, blue: 148.0/255.0, alpha: 1.0).cgColor
            colorBottom = UIColor(red: 35.0/255.0, green: 188.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        case .sixMonths:
            colorTop =  UIColor(red: 255.0/255.0, green: 57.0/255.0, blue: 111.0/255.0, alpha: 1.0).cgColor
            colorBottom = UIColor(red: 155.0/255.0, green: 60.0/255.0, blue: 183.0/255.0, alpha: 1.0).cgColor
        case .yearly:
            colorTop =  UIColor(red: 200.0/255.0, green: 109.0/255.0, blue: 215.0/255.0, alpha:1.0).cgColor
            colorBottom = UIColor(red: 48.0/255.0, green: 35.0/255.0, blue: 174.0/255.0, alpha: 1.0).cgColor
        case .forever:
            colorTop =  UIColor(red: 217.0/255.0, green: 36.0/255.0, blue:36.0/255.0, alpha: 1.0).cgColor
            colorBottom = UIColor(red: 235.0/255.0, green: 175.0/255.0, blue: 56.0/255.0, alpha: 1.0).cgColor
        }
       
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = uiView.bounds
        
        uiView.layer.insertSublayer(gradientLayer, at: 0)
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


extension SubscriptionViewController: CardDelegate {
    
    func cardDidTapInside(card: Card) {
       
    }
}


