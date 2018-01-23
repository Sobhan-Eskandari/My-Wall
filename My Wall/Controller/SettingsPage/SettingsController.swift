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
                    let defaults = UserDefaults.standard
                    let darkMode = defaults.bool(forKey: "darkMode")
                    if(darkMode){
                        $0.value = true
                    }else if (!darkMode){
                        $0.value = false
                    }
                }.onChange { row in
                    if(row.value)!{
                        let defaults = UserDefaults.standard
                        let hasrated = defaults.bool(forKey: "hasrated")
                        if(!hasrated){
                            // The AppID is the only required setup
                            row.value = false
                            Armchair.appID(appID)
                            Armchair.debugEnabled(true)
                            Armchair.appName("My Wall")
                            Armchair.reviewTitle("Please Rate My Wall")
                            Armchair.reviewMessage("We've worked so hard on this app we will be happy if you give us a 5star rating and as appericiation Dark Mode will be avaibale for you")
                            Armchair.cancelButtonTitle("No, i don't care")
                            Armchair.rateButtonTitle("Yes i want Dark Mode!")
                            Armchair.remindButtonTitle("Hit me up later...")
                            Armchair.shouldPromptIfRated(false)
                            // Explicitly disable the storeKit as the default may be true if on iOS 8
                            Armchair.opensInStoreKit(true)
                            Armchair.onDidDeclineToRate() {
                                defaults.set(false, forKey: "hasrated")
                            }
                            Armchair.onDidOptToRate() {
                                defaults.set(true, forKey: "hasrated")
                                Ambience.forcedState =  .invert
                            }
                            Armchair.onDidOptToRemindLater({
                                defaults.set(false, forKey: "hasrated")
                            })
                            Armchair.userDidSignificantEvent(true)
                        }else{
                            Ambience.forcedState =  .invert
                        }
                        print("true")
                    }else{
                        let defaults = UserDefaults.standard
                        Ambience.forcedState =  .regular
                        defaults.set(false, forKey: "darkMode")
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
                    IAPService.shared.getProducts()
                    IAPService.shared.restorePurchases()
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
