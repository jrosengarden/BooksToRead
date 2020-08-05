//
//  ViewController.swift
//  BooksToRead
//
//  Created by Jeff Rosengarden on 8/4/20.
//  Copyright © 2020 Jeff Rosengarden. All rights reserved.
//
//  Main View Controller    = ViewController.swift
//  Detail View Controller  = FilterViewController

//  TODO:  Add AppIcons


import UIKit
import CoreData
import CloudKit

// Custom UITableViewCell for tableView
class BookCell: UITableViewCell {
    
    @IBOutlet weak var bookTitle: UILabel?
    @IBOutlet weak var bookAuthor: UILabel?
    @IBOutlet weak var bookDateAcquired: UILabel?
    @IBOutlet weak var bookGenre: UILabel!
    
}


// Main View Controller
class ViewController: UIViewController {
    
    // obtain handle to CoreData persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Handle to UI elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    // empty array of [Book] to be filled from CoreData
    var books = [Book]()
    
    // Set initial sortOrder to "title"
    var sortOrder:String = "title"
    
    // Set initial filterValue to "all"
    var filterValue:String = "*"
    var predicateValue:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set custom text to <Back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back To Books", style: .plain, target: nil, action: nil)
        
        // Hook up CoreData to tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set initial navBarTitle
        navBarTitle.title = "Books To Read (T)"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Fetch CoreData, sort, display & filter
        fetchBooks()
    }
    
    
    // fetch books stored as Coredata
    // sort them based on the value of sortOrder
    // filter them based on the valu of filterValue
    // redisplay the tableView
    func fetchBooks() {
        do {
            
            // create NSFetchRequest
            let fetchRequest = Book.fetchRequest() as NSFetchRequest<Book>
            
            // set the filtering and sorting on the request
            
            // filter the fetched records badsed on value of filtervalue
            switch filterValue {
            case "*","All":
                predicateValue = "genre LIKE %@ || genre == nil"
                filterValue = "*"
            default:
                predicateValue = "genre CONTAINS %@"
            }
            
            let filterPredicate = NSPredicate(format: predicateValue!, filterValue)
            fetchRequest.predicate = filterPredicate
            
            // sort the fetched records based on value of sortOrder
            let sort = NSSortDescriptor(key: sortOrder, ascending: true)
            fetchRequest.sortDescriptors = [sort]
            
            self.books =  try context.fetch(fetchRequest)
            // reload tableView on main thread since this method
            // will likely be called from the background and we
            // don't this running on a background thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print ("oops")
        }
        
        /*  Sort code no longer needed due to using CoreData sort ability
         
         // Sort the books based on sortOrder value
         self.books = self.books!.sorted { ($0.value(forKeyPath: sortOrder) as! String).localizedCaseInsensitiveCompare(($1.value(forKeyPath: sortOrder) as! String)) == ComparisonResult.orderedAscending }
         
         */
        
    }


    // Method that fires with the sort button is tapped
    // setting the sort order in circular fashion
    // (from title to author, from author to dateAcquired)
    // (and from dateAcquired back to title)
    @IBAction func sortTapped(_ sender: Any) {
        
        switch sortOrder {
        case "title":
            sortOrder = "author"
            navBarTitle.title = "Books To Read (A)"
            break
        case "author":
            sortOrder = "dateAcquired"
            navBarTitle.title = "Books To Read (D)"
            break
        default:
            sortOrder = "title"
            navBarTitle.title = "Books To Read (T)"
            break
        }
        
        fetchBooks()
    }
    
    // function that fires when the + (add) button is tapped
    @IBAction func addTapped(_ sender: Any) {
        
        //Step 1: Create alert
        let alert = UIAlertController(title: "Add a Book", message: "Enter Book Info", preferredStyle: UIAlertController.Style.alert )
        
        //Step 2: Create Save action to alert
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField
            let textField3 = alert.textFields![2] as UITextField
            let textField4 = alert.textFields![3] as UITextField
            
            if textField.text != "" {
                
                let newBook = Book(context: self.context)
                newBook.title = textField.text
                newBook.author = textField2.text
                newBook.dateAcquired = textField3.text
                newBook.genre = textField4.text
                
                // Save modified CoreData
                do {
                    try self.context.save()
                }
                catch {
                    print ("oops")
                }
                
                // Re-fetch the data
                self.fetchBooks()
            }
        }
        
        //Step 3: Setup text fields
        //For first textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Book Title"
            textField.textColor = .red
        }
        //For second textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Author Name"
            textField.textColor = .blue
        }
        //For third textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Date Book Acquired (mm/dd/yy)"
            textField.textColor = .orange
        }
        //For fourth textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Book Genre"
            textField.textColor = .magenta
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
}

// Extensions to ViewController for adherence to the two needed protocols
// UITableViewDelegate and UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Return # of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return # of rows needed
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        cell.bookTitle?.text = books[indexPath.row].title
        cell.bookAuthor?.text = books[indexPath.row].author
        cell.bookDateAcquired?.text = books[indexPath.row].dateAcquired
        cell.bookGenre?.text = books[indexPath.row].genre
        
        // return row
        return cell
    }
    
    // Enable swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Which book to remove
            let bookToRemove = self.books[indexPath.row]
            
            // Remove the book
            self.context.delete(bookToRemove)
            
            // Save the data
            do {
                try self.context.save()
            }
            catch {
                print ("oops")
            }
            
            // Re-fetch the data
            self.fetchBooks()
        }
    }
    
    // function that fires when the a row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Step 0: Retrieve the selected book
        let book = self.books[indexPath.row]
        
        //Step 1: Create alert
        let alert = UIAlertController(title: "Update Book Info", message: "Enter updated book info", preferredStyle: UIAlertController.Style.alert )
        
        //Step 2: Create Update action to alert
        let upDate = UIAlertAction(title: "Update", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField
            let textField3 = alert.textFields![2] as UITextField
            let textField4 = alert.textFields![3] as UITextField
            
            // update book info
            if textField.text != "" {
                book.title = textField.text
                book.author = textField2.text
                book.dateAcquired = textField3.text
                book.genre = textField4.text
                
                // Save modified CoreData
                do {
                    try self.context.save()
                }
                catch {
                    print ("oops")
                }
                
                // Reload the tableview
                self.tableView.reloadData()
            }
        }
        
        //Step 3: Setup text fields
        //For first textfield
        alert.addTextField { (textField) in
            textField.text = self.books[indexPath.row].title
            textField.textColor = .red
        }
        //For second textfield
        alert.addTextField { (textField) in
            textField.text = self.books[indexPath.row].author
            textField.textColor = .blue
        }
        //For third textfield
        alert.addTextField { (textField) in
            textField.text = self.books[indexPath.row].dateAcquired
            textField.textColor = .orange
        }
        //For fourth textfield
        alert.addTextField { (textField) in
            textField.text = self.books[indexPath.row].genre
            textField.textColor = .magenta
        }
        
        //Step 4: Add Save button to alert
        alert.addAction(upDate)
        
        //Step 5: Create Cancel action and add Cancel button to alert
        //Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        
        //Step 6: Present the alert
        self.present(alert, animated:true, completion: nil)
    }
    
    // MARK:  Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a handle to the FilterViewController
        // then set FilterViewController's hndParent variable
        // this allows the detailViewController (FilterViewController) to set a value
        // in the mainViewController (ViewController)
        if let hndFilterViewController = segue.destination as? FilterViewController {
            hndFilterViewController.hndParent = self
            
            // populate the temporary string array in the detail view controller
            // so we can add any new filters to the list of filters
            for item in books {
                hndFilterViewController.passedInFilters.append(item.genre!)
            }
        }
    }
    
}


