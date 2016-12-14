//
//  Supermarket+CoreDataProperties.swift
//  
//
//  Created by Shawn Wu on 11/8/16.
//
//

import Foundation
import CoreData 

extension Supermarket {
    @NSManaged public var id: NSNumber?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var order: NSSet?
}
