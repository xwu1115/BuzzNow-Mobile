//
//  Product+CoreDataProperties.swift
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

extension Product {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var num: NSNumber?
    @NSManaged var price: NSNumber?
    @NSManaged var order: Order?

}
