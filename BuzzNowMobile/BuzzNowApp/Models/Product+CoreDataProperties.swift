//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Shawn Wu on 11/8/16.
//
//

import Foundation
import CoreData

extension Product {
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: NSNumber?
    @NSManaged public var weight: NSNumber?
}
