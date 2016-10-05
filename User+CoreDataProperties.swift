//
//  User+CoreDataProperties.swift
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
