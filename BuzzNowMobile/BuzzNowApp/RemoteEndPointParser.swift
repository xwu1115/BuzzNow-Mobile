//
//  RemoteEndPointParser.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/29/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct RemoteOrderEndPoint {
    static func parseOrder(obj: [[String:AnyObject]]) -> [Order]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        var orders:[Order] = []
        for item in obj {
            let id = item["_id"] as! String
            let order = context.createOrFetchOrder(id)
            order.requester = context.createOrFetchUser(item["requester"] as! String)
            var orderSet:[OrderItem] = []
            if let orderItems = item["order_item"] as? [[String : AnyObject]] {
                for order_item in orderItems {
                    let productId = order_item["product"] as! String
                    let product = context.createOrFetchProduct(productId)
                    product.name = (order_item["name"] as! String)
                    product.price = NSNumber(float: order_item["price"] as! Float)
                    product.weight = NSNumber(float: order_item["weight"] as! Float)
                    let orderItem  = context.createOrFetchOrderItem()
                    orderItem.product = product
                    orderItem.order = order
                    orderItem.num = NSNumber(integer: order_item["quantity"] as! Int)
                    orderSet.append(orderItem)
                }
            }
            order.items = NSSet(array: orderSet)
            orders.append(order)
        }
        appDelegate.saveContext()
        return orders
    }
}

struct RemoteProductEndPoint {
    static func parseProduct(obj: [String:AnyObject]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let id = obj["_id"] as! NSString
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let res = try! context.executeFetchRequest(fetchRequest)
        var product: Product
        if res.count == 0 {
            product = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: context) as! Product
            product.id = obj["_id"] as? String
        } else {
            product = res[0] as! Product
        }
        product.name = obj["name"] as? String
        product.weight = NSNumber(float: obj["weight"] as! Float)
        product.price = NSNumber(float: obj["price"] as! Float)

        appDelegate.saveContext()
    }
}

struct RemoteUserEndPoint {
    static func parseUser(obj: [String:AnyObject]) -> User? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let id = obj["_id"] as! NSString
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let res = try! context.executeFetchRequest(fetchRequest)
        var user: User
        if res.count == 0 {
            user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! User
            user.id = obj["_id"] as? String
        } else {
            user = res[0] as! User
        }
        user.name = obj["name"] as? String
        user.address = obj["address"] as? String
        user.email = obj["email"] as? String

        appDelegate.saveContext()
        return user
    }
}

class RemoteSupermarketEndPoint: NSObject {
    static func parseSupermarket(obj: [String:AnyObject]) -> Supermarket? {
        return nil
    }
}

extension NSManagedObjectContext {
    func getPrimaryCurrentUser() -> User? {
        let id = NSUserDefaults.standardUserDefaults().objectForKey("primaryID") as! String
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let res = try! self.executeFetchRequest(fetchRequest)
        return res.count > 0 ? res[0] as? User : nil
    }

    func createOrFetchOrder(id:String = "") -> Order {
        let fetchRequest = NSFetchRequest(entityName: "Order")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let res = try! executeFetchRequest(fetchRequest)
        var order: Order
        if res.count == 0 {
            order = NSEntityDescription.insertNewObjectForEntityForName("Order", inManagedObjectContext: self) as! Order
            order.id = id == "" ? String(order.objectID) : id
        } else {
            order = res[0] as! Order
        }
        return order
    }

    func createOrFetchProduct(id:String) -> Product {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let res = try! executeFetchRequest(fetchRequest)
        var product: Product
        if res.count == 0 {
            product = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: self) as! Product
            product.id = id
        } else {
            product = res[0] as! Product
        }
        return product
    }

    func createOrFetchUser(id:String = "") -> User {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let res = try! executeFetchRequest(fetchRequest)
        var user: User
        if res.count == 0 {
            user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self) as! User
            user.id = id
        } else {
            user = res[0] as! User
        }
        return user
    }

    func createOrFetchOrderItem(id:String = "") -> OrderItem {
        let fetchRequest = NSFetchRequest(entityName: "OrderItem")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let res = try! executeFetchRequest(fetchRequest)
        var orderItem: OrderItem
        if res.count == 0 {
            orderItem = NSEntityDescription.insertNewObjectForEntityForName("OrderItem", inManagedObjectContext: self) as! OrderItem
            orderItem.id = id == "" ? String(orderItem.objectID) : id
        } else {
            orderItem = res[0] as! OrderItem
        }
        return orderItem
    }

    func primaryUser() -> User {
        //let id = "57ef77aa81e25438e97d1448"
        //let id = "57ef666f81e25438e97d1446"
        let id = NSUserDefaults.standardUserDefaults().objectForKey("primaryID") as! String
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        let res = try! executeFetchRequest(fetchRequest)
        return res[0] as! User
    }
}
