//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var address: String?
    @NSManaged var complete_order_num: NSNumber?
    @NSManaged var email: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var request_order_num: NSNumber?
    @NSManaged var complete_order: Order?
    @NSManaged var request_order: Order?

}
