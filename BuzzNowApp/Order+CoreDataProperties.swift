//
//  Order+CoreDataProperties.swift
//  
//
//  Created by Shawn Wu on 10/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Order {

    @NSManaged var creation_time: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var status: NSNumber?
    @NSManaged var buyer: User?
    @NSManaged var location: Supermarket?
    @NSManaged var products: NSSet?
    @NSManaged var requester: User?

}
