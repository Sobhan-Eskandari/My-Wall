//
//  SettingsController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/23/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import SVProgressHUD

class SettingsController: UIViewController {

    @IBOutlet weak var screenshotsCollectionView: UICollectionView!
    var screnshots = ["iPhone1","iPhone2","iPhone3","iPhone4","iPhone5"]
    @IBOutlet weak var buttonsStackview: UIStackView!
    @IBOutlet weak var restorePurchaseBtn: UIButton!
    @IBOutlet weak var rateAppBtn: UIButton!
    @IBOutlet weak var removeAdBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeButtons(button: restorePurchaseBtn)
        customizeButtons(button: rateAppBtn)
        customizeButtons(button: removeAdBtn)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            buttonsStackview.axis = .horizontal
//            buttonsStackview.distribution = .equalSpacing
        }else{
            buttonsStackview.axis = .vertical
        }
        
        // Setup navigation controller
        Extensions.clearNavbar(controller: self.navigationController!)
        self.view.backgroundColor = ColorPallet.MainColor()
    }
    
    @IBAction func removeAds(_ sender: Any) {
        SwiftyStoreKit.purchaseProduct(IAPProducts.removeAd.rawValue, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let product):
                UserDefaults.standard.set(true, forKey: "isPro")
            case .error(let error):
                print("\(error)")
            }
        }
    }
    
    func customizeButtons(button:UIButton) {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorPallet.ActiveColor().cgColor
        button.backgroundColor = UIColor(red:0.33, green:0.36, blue:0.41, alpha:1.00)
    }
    
    @IBAction func restorePurchase(_ sender: Any) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                SVProgressHUD.showSuccess(withStatus: "Purchase restored Successfully")
                UserDefaults.standard.set(true, forKey: "isPro")
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    @IBAction func rateApp(_ sender: Any) {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func downloadPenman(_ sender: Any) {
        openAppStore()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func openAppStore() {
        if let url = URL(string: "https://itunes.apple.com/us/app/penman-speak-your-notes/id1434184098?ls=1&mt=8"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenShotCell", for: indexPath) as! WallpaperCell
        cell.wallImage.image = UIImage(named: screnshots[indexPath.row])
        // Configure the cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: implement device size based colums
        return CGSize(width: 250, height: 520)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
}
