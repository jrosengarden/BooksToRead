# BooksToRead
## App Overview
BooksToRead is a simple, TableView driven, iOS application that will help you maintain a list of books that you've acquired but have not yet read. The app allows you to optionally filter the books displayed by a specific genre<br/>
## Detail On Books
- Books added to the list have Title, Author Name, Date Acquired and Genre data fields.<br/>
- Books can be sorted by Title, by Author or by Date Acquired.<br/>
- Books can be added by tapping the Add (plus sign) button.<br/>
- Books can be edited by tapping on the row containing the book to be edited.<br/>
- Books can be deleted by swiping right-to-left on the book to be deleted.<br/>
- Books can be sorted by tapping the Sort (up/down arrows) button<ol>
- Sorting will occur in a circular fashion with each tap of the Sort button<br>
(Title first, Author second, Date Acquired third then back to title, etc.)<br>
- The current sort order is indicated with a single character at the end of the title contained within the parenthesis<br>
(T) indicates Sorted by Title<br>
(A) indicates Sorted by Author<br>
(D) indicates Sorted by Date Acquired<br.

## Detail on Genre Filters
- A Genre entered on a book is automatically added to the list of Filters
- Genre Filters can be accessed by tapping the Filter (3 horizontally stacked lines) button
- Genre Filters can be manually added from the Filter tableView but is really unnecessary due to Genre's entered with a book automatically added to the list of Genre Filters.
- Genre Filters can be manually deleted from the Filter tableView but will automatically be added back if still in use as a Genre for any books
- Genre Filters are automatically sorted alphabetically
- Genre Filters can be deleted by swiping right-to-left on the Genre Filter to be deleted
- The *All* Genre Filter is automatically added to the list of Genre Filters
- THE *All* Genre Filter can not be deleted as it is the "default" Genre Filter
- Tapping on a Genre Filter will return you to the Book TableView which will now be filtered to *ONLY* show books belonging to the selected Genre Filter
- The list of books is initially filtered by "All" genres.<br/>

#### Special Notes
- BooksToRead utilizes CoreData<ol>
- This allows the data you enter to persist in a database on your device</ol>
- BooksToRead utilizes CloudKit<ol>
- This allows you to sync the data in BooksToRead between your various devices
- This requires a valid, active, iCloud account that each device must be signed into</ol>

NOTE:  App icons were generated using the web tool at: https://appicon.co
