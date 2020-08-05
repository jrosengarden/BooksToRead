# BooksToRead

BooksToRead is a simple, TableView driven, iOS application that will help you maintain a list of books you've acquired but have not yet read. 
Books added to the list have Title, Author Name, Date Acquired, and Genre data fields available.  
Books can be sorted by Title, by Author or by Date Acquired.
Books can be added by tapping the Add (plus sign) button
Books can be edited by tapping on the row containing the book to be edited
Genre Filters can be accessed by tapping the Filter (3 vertical stacked lines) button (See below detail on Genre's)
Books can be deleted by swiping right-to-left on the book 

Books can be sorted by tapping the Sort (up/down arrow) button
    Sorting will occur in a cicurlar fashion with each tap of the Sort button; Title first, Author 2nd, Date Acquired 3rd then back to Title, etc.
    The current sort order is indicated with a single character at the end of the title, contained within the parenthesis.
    (T) indicates Sorted By Title
    (A) indicates Sorted By Author
    (D) indicates Sorted by Date Acquired
    
    
Genre Filters are automatically added to the list of filters which can be accessed from the main tableView with the Filter (3 vertical stacked lines) button
    Genre's can be manually added when viewing the Genre tableView but this is really unnecessary as the application adds them automatically when switching
    views from the main book tableView to the filter tableView.
    Genre's can be deleted manually when viewing the Genre tableView but will be automatically added back if the genre is still being used on any books
    Genre's are automatically sorted alphabetically
    Filters can be deleted by swiping right-to-left on the filter
    The "All" filter is initially added, automatically,  the 1st time the Filters button is tapped.
    The "All" filter can not be deleted as it is the 'default' filter.
    
    BooksToRead utilized both CoreData and CloudKit functionallity.
    This allows you to load BooksToRead on multiple devices and they will remain synced (Books and Filters) via the cloud.
      NOTE:  A valid user iCloud account is required and devices must be signed into that iCloud account in order for syncing across devices to occur
    
