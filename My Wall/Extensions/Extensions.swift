//
//  Extensions.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/23/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation
import UIKit

class Extensions {

    static func clearNavbar(controller:UINavigationController) {
        // Setup navigation controller

        controller.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        controller.navigationBar.shadowImage = UIImage()
        controller.navigationBar.setValue(true, forKey: "hidesShadow")
        controller.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarView?.backgroundColor = ColorPallet.MainColor()
        controller.navigationBar.backgroundColor = ColorPallet.MainColor()
    }
    
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension UIButton {
    func addBlurEffect()
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}
