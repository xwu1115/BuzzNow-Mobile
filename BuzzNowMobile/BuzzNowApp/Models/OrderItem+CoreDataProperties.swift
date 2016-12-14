//
//  OrderItem+CoreDataProperties.swift
//  
//
//  Created by Shawn Wu on 11/8/16.
//
//

import Foundation
import CoreData

extension OrderItem {
    @NSManaged public var id: String?
    @NSManaged public var num: NSNumber?
    @NSManaged public var order: Order?
    @NSManaged public var product: Product?
}
