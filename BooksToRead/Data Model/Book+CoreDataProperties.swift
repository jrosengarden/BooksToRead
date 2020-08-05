//
//  Book+CoreDataProperties.swift
//  BooksToRead
//
//  Created by Jeff Rosengarden on 8/5/20.
//  Copyright © 2020 Jeff Rosengarden. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var dateAcquired: String?
    @NSManaged public var genre: String?
    @NSManaged public var title: String?

}
