//
//  OrderItem+CoreDataClass.swift
//  
//
//  Created by Shawn Wu on 11/8/16.
//
//

import Foundation
import CoreData

@objc(OrderItem)
public class OrderItem: NSManagedObject {
    var totalPrice: Float {
        return Float((product?.price ?? 0)) * Float(num ?? 0)
    }
}
