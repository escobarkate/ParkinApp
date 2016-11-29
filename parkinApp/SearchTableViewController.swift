//
//  SearchTableViewController.swift
//  parkinApp
//
//  Created by cdt creatic on 28/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating{
    
    let items = ["Mac","iPhone","Apple Watch","iPad"]
    //let items = [String] ()
    var filteredItems = [String]()
    var searchController = UISearchController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController : nil)
        searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.reloadData()
        /*self.resultSearchController = UISearchController(searchResultsController : nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return filteredItems.count
        }
        else{
            return items.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if searchController.isActive{
            if let nameLabel = cell.viewWithTag(100) as? UILabel {
                nameLabel.text = filteredItems[indexPath.row]
            }
        }else{
            if let nameLabel = cell.viewWithTag(100) as? UILabel {
                nameLabel.text = items[indexPath.row]
            }
        }
        return cell
    }
    
  
   
    func updateSearchResults(for searchController: UISearchController) {
        
       filteredItems.removeAll(keepingCapacity: false)
        
        filteredItems = items.filter{
            item in
            
            item.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        tableView.reloadData()
        
        
    }
 
    


}
