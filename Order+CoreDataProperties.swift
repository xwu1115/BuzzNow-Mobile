//
//  Order+CoreDataProperties.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/26/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
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
    @NSManaged var buyer: NSManagedObject?
    @NSManaged var location: NSManagedObject?
    @NSManaged var products: NSSet?
    @NSManaged var requester: NSManagedObject?

}
