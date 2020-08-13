//
//  FilterViewController.swift
//  BooksToRead
//
//  Created by Jeff Rosengarden on 8/4/20.
//  Copyright © 2020 Jeff Rosengarden. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

// Custom UITableViewCell for filterTableView
class FilterCell:UITableViewCell {
    @IBOutlet var filterName: UILabel?
}

// Detail view controller
class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // obtain handle to CoreData persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // handle back to the parent (calling) view controller
    var hndParent:ViewController?
    
    // empty arrays to use for auto-adding filters
    var passedInFilters = [String]()            // filters currently used in ViewController
    var existingFilters = [String]()            // existing Coredata filters
    
    // handle to UI elements
    @IBOutlet var filterTableView: UITableView!
    @IBOutlet weak var cellImage: UIImageView!
    
    // empty array of [Genre] to hold filters
    var filters = [Genre]()
    
    // ID Tag for UIImage in tableView Cell
    let cellID:Int = 1000
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hook up the filter data with the filterTableView
        filterTableView.delegate = self
        filterTableView.dataSource = self
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // fetch, sort, redisplay the filters
        fetchFilters()
        
        // Add "All" to the passedInFilters to insure it
        // gets added if it doesn't already exist since
        // "All" is the default filter
        passedInFilters.append("All")
        
        // Populate the existingFilters array
        for item in filters {
            existingFilters.append(item.genre!)
        }
        
        // Add any filter from passedInFilters that does not
        // exist in existingFilters.  This will save the
        // user from having to manually populate the filters
        // and has the added benefit of only adding filters
        // that have actually been used
        for item in passedInFilters {
            if item != "" {
                if !existingFilters.contains(item) {
                    
                    // add item to existingFilters in case multiple
                    // books, for the same Genre, were added
                    existingFilters.append(item)
                    
                    let filterToAdd = Genre(context: self.context)
                    filterToAdd.genre = item
                    // Save modified CoreData
                    do {
                        try self.context.save()
                    }
                    catch {
                        print ("oops")
                    }
                    
                }
            }
        }
        
        // Re-fetch, re-sort and re-display the filters
        fetchFilters()

    }
    
    // fetch filters stored as Coredata
    // sort them 
    // redisplay the tableView
    func fetchFilters() {
        do {
            
            // create NSFetchRequest
            let fetchRequest = Genre.fetchRequest() as NSFetchRequest<Genre>
            
            // set the filtering and sorting on the request
            
            // Example of using filter ability
            //let filterPredicate = NSPredicate(format: "title CONTAINS %@", "Hawaii")
            //request.predicate = filterPredicate
            
            // sort the fetched records based on value of sortOrder
            let sort = NSSortDescriptor(key: "genre", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            
            self.filters =  try context.fetch(fetchRequest)
            // reload tableView on main thread since this method
            // will likely be called from the background and we
            // don't this running on a background thread
            DispatchQueue.main.async {
                self.filterTableView.reloadData()
            }
        }
        catch {
            print ("oops")
        }
        
    }

    
    // function that fires when the + (add) button is tapped
    @IBAction func addTapped(_ sender: Any) {
        
        //Step 1: Create alert
        let alert = UIAlertController(title: "Add A New Filter", message: "Enter Filter Name", preferredStyle: UIAlertController.Style.alert )
        
        //Step 2: Create Save action to alert
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            
            if textField.text != "" {
                
                let newFilter = Genre(context: self.context)
                newFilter.genre = textField.text
                
                // Save modified CoreData
                do {
                    try self.context.save()
                }
                catch {
                    print ("oops")
                }
                
                // Re-fetch the data
                self.fetchFilters()
            }
        }
        
        //Step 3: Setup text fields
        //For first textfield
        alert.addTextField { (textField) in
            textField.placeholder = "New Filter Name"
            textField.textColor = .red
        }
        
        //Step 4: Add Save button to alert
        alert.addAction(save)
        
        //Step 5: Create Cancel action and add Cancel button to alert
        //Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        
        //Step 6: Present the alert
        self.present(alert, animated:true, completion: nil)
        
    }
    
    // Enable swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // if filter deleted is current filter
            // then reset current filter to '*'
            if filters[indexPath.row].genre == hndParent?.filterValue {
                hndParent?.filterValue = "*"
            }
            
            // Which filter to remove
            let filterToRemove = self.filters[indexPath.row]
            
            // Don't remove filter "All" as it's the default
            if filterToRemove.genre != "All" {
                // Remove the filter
                self.context.delete(filterToRemove)
                
                // Save the data
                do {
                    try self.context.save()
                }
                catch {
                    print ("oops")
                }
                
                // Re-fetch the data
                self.fetchFilters()
                
                
            }
        }
    }
    
    // function that fires when the a row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set filterValue in ViewController then
        // pop back to ViewController
        hndParent?.filterValue = filters[indexPath.row].genre ?? "*"
        navigationController?.popToRootViewController(animated: true)
            
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filters.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = filterTableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        
        // set current cell's label
        cell.filterName?.text = filters[indexPath.row].genre
        
        // Set the UIImage in the cell with the filter image
        let cellImage = cell.viewWithTag(cellID) as! UIImageView
        let cellConfig = UIImage.SymbolConfiguration(pointSize: 5, weight: .ultraLight, scale: .small)
        cellImage.image = UIImage(systemName: "line.horizontal.3.decrease.circle", withConfiguration: cellConfig)
        
        // display the filter SF Symbol to the right side of the cell
        // and set the cell text color to systemBlue and fontsize 24
        // if this cell is being set to the current/active filter
        if filters[indexPath.row].genre == hndParent?.filterValue || ((filters[indexPath.row].genre == "*" || filters[indexPath.row].genre == "All") && (hndParent?.filterValue == "All" || hndParent?.filterValue == "*")) {
 
            cell.filterName?.textColor = UIColor.systemBlue
            cell.filterName?.font = UIFont.systemFont(ofSize: 24)
            cellImage.isHidden = false

        } else {
            cell.filterName?.textColor = UIColor.black
            cell.filterName?.font = UIFont.systemFont(ofSize: 22)
            cellImage.isHidden = true
            

        }

        return cell
    }
    

}
