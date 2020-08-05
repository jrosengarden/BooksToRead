//
//  Genre+CoreDataProperties.swift
//  BooksToRead
//
//  Created by Jeff Rosengarden on 8/5/20.
//  Copyright © 2020 Jeff Rosengarden. All rights reserved.
//
//

import Foundation
import CoreData


extension Genre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre")
    }

    @NSManaged public var genre: String?

}
