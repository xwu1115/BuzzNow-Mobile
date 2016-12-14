//
//  Order+CoreDataClass.swift
//  
//
//  Created by Shawn Wu on 11/8/16.
//
//

import Foundation
import CoreData

public class Order: NSManagedObject {
    func content() -> [String: AnyObject]? {
        if let orderItemArray = self.items?.allObjects as? [OrderItem] {
            let arr:[[String: AnyObject]] = orderItemArray.flatMap {
                guard let id = $0.product?.id, let num = $0.num else { return nil }
                return ["product": id, "quantity": num]
            }
            return ["requester": (requester?.id ?? ""), "status": 0, "orderItem": arr, "buyer": ""]
        } else {
            return nil
        }
    }
}
