//
//  ViewCustomization.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/24/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//
// This class is for general customization

import UIKit


class ViewCustomization {
    // MARK: - Customises Searchbox Design
    class func customiseSearchBox(searchBar:UISearchBar) {
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        for s in searchBar.subviews[0].subviews {
            if s is UITextField {
                s.layer.shadowColor = (UIColor(red:0.66, green:0.71, blue:0.78, alpha:0.8)).cgColor
                s.layer.shadowOffset = CGSize(width: 0, height: 0)
                s.layer.shadowOpacity = 0.7
                s.layer.shadowRadius = 6.0 //Here your control your blur
                s.layer.masksToBounds =  false
            }
        }
    }
    
    class func customiseCard(s:UIView) {
        s.layer.shadowColor = (UIColor(red:0.66, green:0.71, blue:0.78, alpha:0.8)).cgColor
        s.layer.shadowOffset = CGSize(width: 0, height: 0)
        s.layer.shadowOpacity = 0.7
        s.layer.shadowRadius = 6.0 //Here your control your blur
//        s.layer.masksToBounds =  true
    }
    
}

