//
//  CustomOverlayView.swift
//  INSPhotoGallery
//
//  Created by Michal Zaborowski on 04.04.2016.
//  Copyright © 2016 Inspace Labs Sp z o. o. Spółka Komandytowa. All rights reserved.
//

import UIKit
import INSNibLoading
import INSPhotoGallery
import SVProgressHUD
import Alamofire
import AlamofireImage
import PopupDialog

class CustomOverlayView: INSNibLoadedView {
    weak var photosViewController: INSPhotosViewController?
    var actionButton: ActionButton!
    static var imageInfo:CardLayoutInfo? = nil
    // Pass the touches down to other views
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView != self {
            return hitView
        }
        return nil
    }
    
//    @IBAction func closeButtonTapped(_ sender: AnyObject) {
//        photosViewController?.dismiss(animated: true, completion: nil)
//    }
    
}


extension CustomOverlayView: INSPhotosOverlayViewable {
    
    func populateWithPhoto(_ photo: INSPhotoViewable) {
        let downloadImage = UIImage(named: "download.png")!
        let shareImage = UIImage(named: "shareBtn.png")!
        let infoImage = UIImage(named: "infoBtn.png")!
        let selectedPhoto = photo as! INSPhoto
        
        let downloadBtn = ActionButtonItem(title: "Save to Gallery", image: downloadImage)
        downloadBtn.action = { item in
            print(selectedPhoto.getImageUrl())
            SVProgressHUD.show(withStatus: "Downloading...")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            Alamofire.request(selectedPhoto.getImageUrl().absoluteString).responseImage { response in
                debugPrint(response)
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.saveImageToCammeraRoll(image: image)
                    SVProgressHUD.dismiss()
                }
            }
        }
        
        let shareBtn = ActionButtonItem(title: "Share Wallpaper", image: shareImage)
        shareBtn.action = { item in
            let text = CustomOverlayView.imageInfo!.imageUrl
            let textShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view()
            self.photosViewController?.present(activityViewController, animated: true, completion: nil)
        }
        
        let infoBtn = ActionButtonItem(title: "Wallpaper Information", image: infoImage)
        infoBtn.action = { item in
            // Prepare the popup assets
            let title = "Wallpaper Information"
            let message = "Photo By: \(CustomOverlayView.imageInfo?.photographerName ?? "Photographer") \n See more in Uplash"
            let image = UIImage(named: "pexels-photo-103290")

            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message, image: image)
            
            // Create buttons
            let buttonOne = CancelButton(title: "CANCEL") {
                print("You canceled the car dialog.")
            }
            
            // This button will not the dismiss the dialog
            let buttonTwo = DefaultButton(title: "Visit Unsplash", dismissOnTap: false) {
                let url = URL(string: "https://unsplash.com/?utm_source=your_app_name&utm_medium=referral")
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
            
            let buttonThree = DefaultButton(title: "View more of \(CustomOverlayView.imageInfo?.photographerName ?? "Photographer")", height: 60) {
                let url = URL(string: "\(CustomOverlayView.imageInfo!.photographerURL)?utm_source=your_app_name&utm_medium=referral")
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
            
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonThree, buttonTwo, buttonOne])
            
            // Present dialog
            self.photosViewController?.present(popup, animated: true, completion: nil)
        }
        
        
        actionButton = ActionButton(attachedToView: self, items: [downloadBtn,shareBtn,infoBtn])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        
        actionButton.backgroundColor = UIColor(red: 250.0/255.0, green: 42.0/255.0, blue: 0.0/255.0, alpha:1.0)
        
    }
    
    func saveImageToCammeraRoll(image:UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
    }
    
    
    func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        
        if animated {
            self.isHidden = false
            self.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { () -> Void in
                self.alpha = hidden ? 0.0 : 1.0
                }, completion: { result in
                    self.alpha = 1.0
                    self.isHidden = hidden
            })
        } else {
            self.isHidden = hidden
        }
    }
}
