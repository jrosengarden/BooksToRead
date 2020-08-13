//
//  ViewController.swift
//  BooksToRead
//
//  Created by Jeff Rosengarden on 8/4/20.
//  Copyright © 2020 Jeff Rosengarden. All rights reserved.
//
//  Main View Controller    = ViewController.swift
//  Detail View Controller  = FilterViewController

//  ToDO:  How to adjust author name so it's last,first (for sorting)
//  TODO:  Full QA Cycle
//  TODO:  Find out about finalizing CoreData schema to production (from testing)
//  TODO:  Find out about submitting an app into the App store!!!!!  (FINALLY!)
//  TODO:  HUGE TODO: Re-do this app in SwiftUI.  YIKES!


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
    
    // Set initial filterValue to "*" (Wildcard = All)
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
        navBarTitle.title = "BooksToRead (T)"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Fetch CoreData, sort, display & filter
        fetchBooks()
    }
    
    
    // fetch books stored as Coredata
    // sort them based on the value of sortOrder
    // filter them based on the value of filterValue
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
            // don't want this running on a background thread
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
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        
        var infoMsg:String?
        
        // Setup the app instructions for the alert message
        infoMsg = "\n\n===App Overview===\n"
        infoMsg! += "BooksToRead is a simple, TableView driven, iOS application that will help you maintain a list of books that you've acquired but have not yet read.  The app allows you to optionally filter the books displayed by a specific genre\n\n"
        infoMsg! += "==Detail on Books==\n"
        infoMsg! += "- Books added to the list have Title, Author Name, Date Acquired and Genre data fields\n"
        infoMsg! += "- Books can be sorted by Title, by Author or by Date acquired\n"
        infoMsg! += "- Books can be added by tapping the Add (plus sign) button\n"
        infoMsg! += "- Books can be edited by tapping on the row containing the book to be edited\n"
        infoMsg! += "- Books can be sorted by tapping the Sort (up/down arrows) button\n"
        infoMsg! += "- Books can be deleted by swiping, right-to-left, on the row containing the book to be deleted\n"
        infoMsg! += "- The Current Book Sort Order is indicated with a single character, at the end of the title, contained within parenthesis\n\n"
        infoMsg! += "==Detail on Genre Filters==\n"
        infoMsg! += "- A Genre entered on a book is automatically added to the list of filters\n"
        infoMsg! += "- Genre Filters can be accessed by tapping the Filter (3 horizontally stacked lines) button\n"
        infoMsg! += "- Genre Filters can be manually added from the Filter tableView but is really unnecessary due to Genre's entered with a book being automatically added to the list of Genre Filters\n"
        infoMsg! += "- Genre Filters are automatically sorted alphabetically\n"
        infoMsg! += "- Genre Filters can be deleted by swiping right-to-left on the Genre Filter to be deleted\n"
        infoMsg! += "- The 'All' Genre Filter is automatically added to the list of Genre Filters\n"
        infoMsg! += "- The 'All' Genre Filter can not be deleted as it is the 'default' Genre Filter\n"
        infoMsg! += "- Tapping on a Genre Filter will return you to the Book TableView which will now be filtered to only show books belonging to the selected filter\n"
        infoMsg! += "- The list of books is initially filtered by 'All'\n"
        infoMsg! += "- The current/active filter will be displayed in the system blue color, and slightly larger text, as well as displaying the filter symbol (3 stacked horizontal lines) at the right hand edge of that row when viewing the filter tableView\n\n\n"
        infoMsg! += "==Additional Notes==\n"
        infoMsg! += "- BooksToRead utilizes CoreData\n"
        infoMsg! += "- BooksToRead utilizes CloudKit (for syncing data across devices)\n\n"
        infoMsg! += "BooksToRead (v1.0 August 2020) created by Jeff Rosengarden"
        
        // create the alert
        let infoAlert = UIAlertController(title: "BooksToRead", message: infoMsg!, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        infoAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // Change font and color of title
        infoAlert.setTitlet(font: UIFont.boldSystemFont(ofSize: 28), color: UIColor.magenta)
        // Change font and color of message
        infoAlert.setMessage(font: UIFont(name: "Times-Roman", size: 16), color: UIColor.black)
        // Change background color of UIAlertController
        infoAlert.setBackgroundColor(color: UIColor.cyan)
        // Change tint color of UIAlertController (changes the button colors)
        infoAlert.setTint(color: UIColor.black)

        
    // show the alert
    self.present(infoAlert, animated: true, completion: nil)
    }
    

    // Method that fires when the sort button is tapped
    // sets the sort order in circular fashion
    // (from title to author, from author to dateAcquired)
    // (and from dateAcquired back to title)
    @IBAction func sortTapped(_ sender: Any) {
        
        switch sortOrder {
        case "title":
            sortOrder = "author"
            navBarTitle.title = "BooksToRead (A)"
            break
        case "author":
            sortOrder = "dateAcquired"
            navBarTitle.title = "BooksToRead (D)"
            break
        default:
            sortOrder = "title"
            navBarTitle.title = "BooksToRead (T)"
            break
        }
        
        // Fetch CoreData, sort, display & filter
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
                
                // Fetch CoreData, sort, display & filter
                self.fetchBooks()
            }
        }
        
        //Step 3: Setup text fields
        //For first textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
            textField.textColor = .red
        }
        //For second textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Author Name (Last,First)"
            textField.textColor = .blue
        }
        //For third textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Date Acquired (mm/dd/yy)"
            textField.textColor = .orange
        }
        //For fourth textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Genre"
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
            
            // Fetch CoreData, sort, display & filter
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
                
                // Fetch CoreData, sort, display & filter
                self.fetchBooks()
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

// extensions to UIAlertController to allow easy setting of:
// title font and title color
// message font and message color
// background color
// tint color
extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}



