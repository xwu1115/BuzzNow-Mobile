//
//  Order+CoreDataProperties.swift
//  
//
//  Created by Shawn Wu on 11/8/16.
//
//

import Foundation
import CoreData

extension Order {
    @NSManaged public var creation_time: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var status: NSNumber?
    @NSManaged public var buyer: User?
    @NSManaged public var items: NSSet?
    @NSManaged public var location: Supermarket?
    @NSManaged public var requester: User?
}
