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
import SwiftyOnboard
import SVProgressHUD

class SubscriptionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    enum SubscriptionPlans:String {
        case Monthly = "Monthly"
        case sixMonths = "6 Months"
        case yearly = "Yearly"
        case forever = "Forever"
    }
    var SubscriptionPlansCost = ["1.99","7.99","12.99","20.99"]
    
    
    var subscrptionPlans = [SubscriptionPlans.Monthly,SubscriptionPlans.sixMonths,SubscriptionPlans.yearly,SubscriptionPlans.forever] // for now fake images
    var currentPage: Int = 0
    
    var swiftyOnboard: SwiftyOnboard!
    let colors:[UIColor] = [#colorLiteral(red: 0.9980840087, green: 0.3723873496, blue: 0.4952875376, alpha: 1),#colorLiteral(red: 0.2666860223, green: 0.5116362572, blue: 1, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)]
    var titleArray: [String] = ["Welcome to Confess!", "It’s completely anonymous", "Say something positive"]
    var subTitleArray: [String] = ["Confess lets you anonymously\n send confessions to your friends\n and receive confessions from them.", "All confessions sent are\n anonymous. Your friends will only\n know that it came from one of\n their facebook friends.", "Be nice to your friends.\n Send them confessions that\n will make them smile :)"]
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        
//        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
//        view.addSubview(swiftyOnboard)
//        swiftyOnboard.dataSource = self
//        swiftyOnboard.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        
        // In App Purchase
        IAPService.shared.getProducts()
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
    
    @objc func purchaseMonthly() {
        print("purchase Monthly")
        IAPService.shared.purchase(product: .MonthlyPlan)
        
    }
    @objc func purchaseSixMonth() {
        print("purchase 6Month")
        IAPService.shared.purchase(product: .SixMonthsPlan)
    }
    @objc func purchaseYearly() {
        print("purchase Yearly")
        IAPService.shared.purchase(product: .YearlyPlan)
    }
    @objc func purchaseForever() {
        print("purchase Forever")
        IAPService.shared.purchase(product: .ForeverPlan)
    }
    
    
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
        
        cell.costLabel.text = SubscriptionPlansCost[indexPath.row]
        // corner radius
        cell.purchaseBtnLayout.layer.cornerRadius = 10
        
        // border
        cell.purchaseBtnLayout.layer.borderWidth = 1.0
        cell.purchaseBtnLayout.layer.borderColor = UIColor.clear.cgColor
        
        // shadow
        cell.purchaseBtnLayout.layer.shadowColor = UIColor.black.cgColor
        cell.purchaseBtnLayout.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.purchaseBtnLayout.layer.shadowOpacity = 0.5
        cell.purchaseBtnLayout.layer.shadowRadius = 5.0
        setGradientGreenBlue(uiView: cell.purchaseBtnLayout, plan: .forever)
        cell.gradientBc.clipsToBounds = true
        cell.gradientBc.layer.cornerRadius = 10
        cell.subscriptionPlanTitle.text = subscrptionPlans[indexPath.row].rawValue
        
        switch indexPath.row {
        case 0:
            cell.purchaseBtnLayout.addTarget(self, action: #selector(purchaseMonthly), for: .touchUpInside)
        case 1:
            cell.purchaseBtnLayout.addTarget(self, action: #selector(purchaseSixMonth), for: .touchUpInside)
        case 2:
            cell.purchaseBtnLayout.addTarget(self, action: #selector(purchaseYearly), for: .touchUpInside)
        case 3:
            cell.purchaseBtnLayout.addTarget(self, action: #selector(purchaseForever), for: .touchUpInside)
        default:
            print("doenst; work")
        }
        
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
        
        gradientLayer.cornerRadius = 14
        
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
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    
    @objc func showSubscribe() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.swiftyOnboard.alpha = 0.0
        }, completion: {finished in})
    }
    
}

extension SubscriptionViewController:  SwiftyOnboardDelegate, SwiftyOnboardDataSource  {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return 3
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return colors[index]
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
        view.imageView.image = UIImage(named: "onboard\(index)")
        
        //Set the font and color for the labels:
        view.title.font = UIFont(name: "Lato-Heavy", size: 22)
        view.subTitle.font = UIFont(name: "Lato-Regular", size: 16)
        
        //Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray[index]
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        
        overlay.skipButton.isHidden = true
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.continueButton.tag = Int(position)
        
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.continueButton.setTitle("Continue", for: .normal)
        } else if currentPage == 2.0 {
            overlay.continueButton.setTitle("Get Started!", for: .normal)
            
            overlay.continueButton.addTarget(self, action: #selector(showSubscribe), for: .touchUpInside)
        }
    }
}




