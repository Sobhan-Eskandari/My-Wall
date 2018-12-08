// The MIT License (MIT)
//
// Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

import UIKit
import Hero
import SVProgressHUD
import GoogleMobileAds
import AZDialogView

class ImageViewController: UICollectionViewController {
    
    var selectedIndex: IndexPath?
    var panGR = UIPanGestureRecognizer()
    var wallpapers:WallpapersListVM!
    var bookmarkService:BookmarkService!
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.width)
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6286619084449151/1582418876")
        let request = GADRequest()
        interstitial.load(request)
        view.layoutIfNeeded()
        collectionView!.reloadData()
        self.collectionView.backgroundColor = ColorPallet.MainColor()
        self.navigationController?.navigationBar.barStyle = .black
        setStatusBarBackgroundColor(.clear)
        if let selectedIndex = selectedIndex {
            collectionView!.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
        }
        
        panGR.addTarget(self, action: #selector(pan))
        panGR.delegate = self
        collectionView?.addGestureRecognizer(panGR)
        bookmarkService = BookmarkService(moc: AppDelegate.moc)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       showButtons()
    }
    
    @objc func saveToGalleryTapped() {
        print("saved to gallery")
        if let index = selectedIndex?.row {
            let url = wallpapers.wallpapers[index].fullHDURL
            SVProgressHUD.show(withStatus: "Downloading...")
            WebService.downloadImage(url: url) { (image) in
                SVProgressHUD.showSuccess(withStatus: "Done")
                self.save(savingImage: image)
                self.showAd()
            }
        }
    }
    @objc func wallInfoTapped() {
        print("saved to gallery")
        hideButtons()
        guard let index = selectedIndex?.row else {return}
        let dialog = AZDialogViewController(title: wallpapers.wallpapers[index].user, message: "See more in Pixabay")
        dialog.imageHandler = { (imageView) in
            imageView.kf.setImage(with: URL(string: self.wallpapers.wallpapers[index].userImageURL))
            imageView.contentMode = .scaleAspectFill
            return true //must return true, otherwise image won't show.
        }
        dialog.addAction(AZDialogAction(title: "Visit Pixabay") { (dialog) -> (Void) in
            //add your actions here.
            guard let url = URL(string: "https://pixabay.com/") else { return }
            UIApplication.shared.open(url)
            dialog.dismiss(animated: true, completion: {
                self.showButtons()
            })
        })
        dialog.addAction(AZDialogAction(title: "View in Pixabay") { (dialog) -> (Void) in
            //add your actions here.
            guard let url = URL(string: self.wallpapers.wallpapers[index].imageURL) else { return }
            UIApplication.shared.open(url)
            dialog.dismiss(animated: true, completion: {
                self.showButtons()
            })
        })
        dialog.show(in: self)
    }
    @objc func bookmarkWallTapped(sender:UIButton) {
        print("saved to gallery")
        if let index = selectedIndex?.row {
            let id = wallpapers.wallpapers[index].id
            if bookmarkService.isExist(id: Int32(id)) {
                sender.setTitleColor(.white, for: .normal)
                wallpapers.deleteBookmark(id: Int32(id))
            } else {
                sender.setTitleColor(.red, for: .normal)
                wallpapers.saveBookmark(wallpaper: wallpapers.wallpapers[(selectedIndex?.row)!])
            }
        }
        
    }
    @objc func shareWallTapped() {
        // text to share
        let text = wallpapers.wallpapers[(selectedIndex?.row)!].pageURL
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func save(savingImage:UIImage) {
        UIImageWriteToSavedPhotosAlbum(savingImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disspeareing")
        hideButtons()
    }
    
    func hideButtons() {
        let window = UIApplication.shared.keyWindow!
        for subview in window.subviews {
            if subview.tag == 100 || subview.tag == 101 || subview.tag == 102 || subview.tag == 103 {
                subview.removeFromSuperview()
            }
        }
    }
    func showButtons() {
        let window = UIApplication.shared.keyWindow!
        let saveToGalleryBtn = UIButton(frame: CGRect(x: 16, y: self.collectionView.bounds.height - 100, width: 170, height: 50))
        saveToGalleryBtn.setTitle(" Save to Gallery", for: .normal)
        saveToGalleryBtn.setTitleColor(ColorPallet.ActiveColor(), for: .normal)
        saveToGalleryBtn.titleLabel?.font = UIFont(name: "FontAwesome5ProSolid", size: 17)
        saveToGalleryBtn.tag = 100
        window.addSubview(saveToGalleryBtn)
        saveToGalleryBtn.addBlurEffect()
        saveToGalleryBtn.layer.cornerRadius = 25
        saveToGalleryBtn.clipsToBounds = true
        saveToGalleryBtn.addTarget(self, action: #selector(saveToGalleryTapped), for: .touchUpInside)
        
        let wallInfoBtn = UIButton(frame: CGRect(x: 196, y: self.collectionView.bounds.height - 100, width: 50, height: 50))
        wallInfoBtn.setTitle("", for: .normal)
        wallInfoBtn.setTitleColor(ColorPallet.ActiveColor(), for: .normal)
        wallInfoBtn.titleLabel?.font = UIFont(name: "FontAwesome5ProSolid", size: 20)
        wallInfoBtn.tag = 101
        window.addSubview(wallInfoBtn)
        //        self.collectionView.insertSubview( wallInfoBtn, aboveSubview: self.collectionView)
        wallInfoBtn.addBlurEffect()
        wallInfoBtn.layer.cornerRadius = 25
        wallInfoBtn.clipsToBounds = true
        wallInfoBtn.addTarget(self, action: #selector(wallInfoTapped), for: .touchUpInside)
        
        let shareWallBtn = UIButton(frame: CGRect(x: 256, y: self.collectionView.bounds.height - 100, width: 50, height: 50))
        shareWallBtn.setTitle("", for: .normal)
        shareWallBtn.setTitleColor(ColorPallet.ActiveColor(), for: .normal)
        shareWallBtn.titleLabel?.font = UIFont(name: "FontAwesome5ProSolid", size: 20)
        shareWallBtn.tag = 102
        window.addSubview(shareWallBtn)
        shareWallBtn.addBlurEffect()
        shareWallBtn.layer.cornerRadius = 25
        shareWallBtn.clipsToBounds = true
        shareWallBtn.addTarget(self, action: #selector(shareWallTapped), for: .touchUpInside)
        
        let  bookmarkWallBtn = UIButton(frame: CGRect(x: 316, y: self.collectionView.bounds.height - 100, width: 50, height: 50))
        bookmarkWallBtn.setTitle("", for: .normal)
        bookmarkWallBtn.setTitleColor(ColorPallet.ActiveColor(), for: .normal)
        bookmarkWallBtn.titleLabel?.font = UIFont(name: "FontAwesome5ProSolid", size: 20)
        bookmarkWallBtn.tag = 103
        window.addSubview( bookmarkWallBtn)
        bookmarkWallBtn.addBlurEffect()
        bookmarkWallBtn.layer.cornerRadius = 25
        bookmarkWallBtn.clipsToBounds = true
        bookmarkWallBtn.addTarget(self, action: #selector(bookmarkWallTapped(sender:)), for: .touchUpInside)
        
        
        if let index = selectedIndex?.row {
            let id = wallpapers.wallpapers[index].id
            if bookmarkService.isExist(id: Int32(id)) {
                DispatchQueue.main.async {
                    bookmarkWallBtn.setTitleColor(.red, for: .normal)
                }
            }
        }
        
        self.collectionView.bringSubviewToFront(saveToGalleryBtn)
    }
    
    func showAd() {
        if !UserDefaults.standard.bool(forKey: "isPro") {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for v in (collectionView!.visibleCells as? [ScrollingImageCell])! {
            v.topInset = topLayoutGuide.length
        }
    }
    
    func setStatusBarBackgroundColor(_ color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    @objc func pan() {
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / collectionView!.bounds.height
        switch panGR.state {
        case .began:
            hero.dismissViewController()
        case .changed:
            Hero.shared.update(progress)
            if let cell = collectionView?.visibleCells[0]  as? ScrollingImageCell {
                let currentPos = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
                Hero.shared.apply(modifiers: [.position(currentPos)], to: cell.imageView)
            }
        default:
            if progress + panGR.velocity(in: nil).y / collectionView!.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}

extension ImageViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallpapers.wallpapers.count
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? ScrollingImageCell)!
        imageCell.imageView.kf.setImage(with: URL(string: wallpapers.wallpapers[indexPath.row].fullHDURL))
        imageCell.imageView.hero.id = "image_\(wallpapers.wallpapers[indexPath.row].id)"
        imageCell.imageView.hero.modifiers = [.position(CGPoint(x:view.bounds.width/3, y:view.bounds.height/3)), .scale(0.8), .fade]
        imageCell.topInset = topLayoutGuide.length
        imageCell.imageView.isOpaque = true
        return imageCell
    }
}

extension ImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}

extension ImageViewController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let cell = collectionView?.visibleCells[0] as? ScrollingImageCell,
            cell.scrollView.zoomScale == 1 {
            let v = panGR.velocity(in: nil)
            return v.y > abs(v.x)
        }
        return false
    }
}

