//
//  CollectionsViewController.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 12/1/17.
//  Copyright © 2017 Sobhan Eskandari. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var collectionsTableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var collections = ["hi","helloe","buy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionsTableview.delegate = self
        collectionsTableview.dataSource = self
        collectionsTableview.rowHeight = 200.0
        
        ViewCustomization.customiseSearchBox(searchBar: searchBar)
        
        collectionsTableview.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        collectionsTableview.addInfiniteScroll { (tableView) -> Void in
            // update table view
            
            let collCount = self.collections.count
            self.collections.append("de")
            self.collections.append("dee")
            let (start, end) = (collCount, collCount + 2)
            let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
           
            self.collectionsTableview.beginUpdates()
            self.collectionsTableview.insertRows(at: indexPaths, with: .automatic)
            self.collectionsTableview.endUpdates()
            
            tableView.finishInfiniteScroll()
           
        }
    }

    fileprivate func performFetch(_ completionHandler: (() -> Void)?) {
       
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

extension CollectionsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableCell.identifier, for: indexPath) as! CollectionTableCell
        return cell
    }
}
