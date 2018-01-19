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

class SettingsController: FormViewController,MFMailComposeViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Bonus")
            <<< SwitchRow(){ row in
                row.title = "Dark Mode"
                }.onChange { row in
                    row.title = (row.value ?? false) ? "The title expands when on" : "The title"
                    row.updateCell()
                    self.navigationItem.ambience = true
        }
        form +++ Section("More Info")
            <<< ButtonRow("We'll be happy to hear from you - Contact Us") { (row: ButtonRow) in
                row.title = row.tag
                sendEmail()
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["paul@hackingwithswift.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
