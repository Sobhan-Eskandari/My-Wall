//
//  SettingsController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 1/18/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import UIKit
import Eureka
import MessageUI
import Ambience
import StoreKit
import Armchair

class SettingsController: FormViewController,MFMailComposeViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            
            Section("Bonus")
            
            <<< SwitchRow("Dark Mode") {
                $0.title = $0.tag
                }.onChange { row in
                    if(row.value)!{
//                        SKStoreReviewController.requestReview()
//                        Ambience.forcedState =  .invert
                        // The AppID is the only required setup
                        Armchair.appID(appID)
                        
                        // Debug means that it will popup on the next available change
                        Armchair.debugEnabled(true)
                        
                        // This overrides the default of NO in iOS 7. Instead of going to the review page in the App Store App,
                        //  the user goes to the main page of the app, in side of this app. Downsides are that it doesn't go directly to
                        //  reviews and doesn't take af sfiliate codes
                        Armchair.opensInStoreKit(true)
                        
                        // If you are opening in StoreKit, you can change whether or not to animated the push of the View Controller
                        Armchair.usesAnimation(true)
                        
                        // true here means it is ok to show, but it doesn't matter because we have debug on.
                        Armchair.userDidSignificantEvent(true)
                        print("true")
                    }else{
                        Ambience.forcedState =  .regular
                    }
                }
            
            +++ Section("More Info")
            <<< ButtonRow("We'll be happy to hear from you - Contact Us") {
                $0.title = $0.tag
                }.onCellSelection { cell, row in
                    self.sendEmail()
                }
            
            <<< ButtonRow("Restore Purchase") {
                $0.title = $0.tag
                }.onCellSelection { cell, row in
                    IAPService.shared.restorePurchase()
            }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["serpro@icloud.com"])
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
