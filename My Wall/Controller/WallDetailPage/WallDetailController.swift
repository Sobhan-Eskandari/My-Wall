//
//  WallDetailController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 12/5/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit

class WallDetailController: UIViewController {

    var actionButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.addSubview(visualEffectView)
        self.navigationController?.navigationBar.sendSubview(toBack: visualEffectView)
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.layer.zPosition = -1
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let downloadImage = UIImage(named: "download.png")!
        let shareImage = UIImage(named: "shareBtn.png")!
        let infoImage = UIImage(named: "infoBtn.png")!
        
        let downloadBtn = ActionButtonItem(title: "Save to Gallery", image: downloadImage)
        downloadBtn.action = { item in print("Saved to gallery...") }
        
        let shareBtn = ActionButtonItem(title: "Share Wallpaper", image: shareImage)
        shareBtn.action = { item in print("Shared Wall...") }
        
        let infoBtn = ActionButtonItem(title: "Wallpaper Information", image: infoImage)
        infoBtn.action = { item in print("Image info...") }

        
        actionButton = ActionButton(attachedToView: self.view, items: [downloadBtn,shareBtn,infoBtn])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        
        actionButton.backgroundColor = UIColor(red: 250.0/255.0, green: 42.0/255.0, blue: 0.0/255.0, alpha:1.0)
        
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
