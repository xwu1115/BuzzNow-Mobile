//
//  User+CoreDataProperties.swift
//  
//
//  Created by Shawn Wu on 11/8/16.
//
//

import Foundation
import CoreData

extension User {
    @NSManaged public var address: String?
    @NSManaged public var complete_order_num: NSNumber?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var primary: NSNumber?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var request_order_num: NSNumber?
    @NSManaged public var complete_order: NSSet?
    @NSManaged public var request_order: NSSet?
}
