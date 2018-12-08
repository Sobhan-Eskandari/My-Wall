//
//  CategoriesTableController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/23/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import UIKit

class CategoriesTableController: UITableViewController {

    var categoriesListVM:CategoriesListVM!
    var selectedIndexPath = IndexPath(row: 0, section: 0 )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup navigation controller
        Extensions.clearNavbar(controller: self.navigationController!)
        self.tableView.backgroundColor = ColorPallet.MainColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
        categoriesListVM = CategoriesListVM(completion: { (index) in
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesListVM != nil ? categoriesListVM.categories.count : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        cell.title.text = categoriesListVM.categories[indexPath.row].title
        cell.wallpaperListVM = categoriesListVM.categories[indexPath.row].wallpapersListVM
        cell.seeMoreBtn.addTarget(self, action: #selector(showCategoriesDetail(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func showCategoriesDetail(sender:UIButton) {
        guard let cell = sender.superview?.superview as? CategoryCell else {
            return // or fatalError() or whatever
        }
        let indexPath = self.tableView.indexPath(for: cell)
        selectedIndexPath = indexPath!
        performSegue(withIdentifier: "pushToWallpapers", sender: self)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToWallpapers" {
            let destVC = segue.destination as! HomeCollectionController
            destVC.selectedCategory = categoriesListVM.categories[selectedIndexPath.row].title.lowercased()
            destVC.pageTitle = categoriesListVM.categories[selectedIndexPath.row].title
        }
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}


