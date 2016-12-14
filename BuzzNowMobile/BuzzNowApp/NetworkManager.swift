//
//  NetworkManager.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import Foundation
import AFNetworking

class NetworkManager: NSObject {
    let manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let baseUrl = "http://http://138.68.13.194:3000/"
    private let fileStorageBaseUrl = "http://www.xiaolongwu.com/buzznow/"
    let imageQueue: dispatch_queue_t = dispatch_queue_create("image.queue", nil)
    let queue = NSOperationQueue()

    func registerUser(user: User, image: UIImage?, completion: Bool -> Void) {
        guard let param = user.content() else { return }
        let url = NSURL(string: (baseUrl.stringByAppendingString("users")))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(param, options: .PrettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = manager.uploadTaskWithStreamedRequest(request, progress: nil) { (response, obj, error) in
            if error == nil {
                if let obj = obj as? [String: AnyObject], let id = obj["_id"] as? String {
                    user.id = id
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.saveContext()
                }
                NSUserDefaults.standardUserDefaults().setObject(user.id!, forKey: "primaryID")
                completion(true)
            } else {
                completion(false)
            }
        }
        task.resume()
    }

    func fetchProducts() {
        let url = NSURL(string: (baseUrl.stringByAppendingString("products")))
        createDownloadTask(url!) { (res, obj, error) in
            if let obj = obj as? [[String:AnyObject]] {
                _ = obj.flatMap{RemoteProductEndPoint.parseProduct($0)}
            }
        }
    }

    func fetchOrders() {
        let url = NSURL(string: (baseUrl.stringByAppendingString("availableOrders")))
        createDownloadTask(url!) { [unowned self] (res, obj, error) in
            if let obj = obj as? [[String: AnyObject]] {
                if let orders = RemoteOrderEndPoint.parseOrder(obj) {
                    self.queue.addOperationWithBlock({
                        for order in orders {
                            self.fetchUser(order.requester?.id ?? "", completion: { user -> Void in
                                order.requester = user
                            })
                        }
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.saveContext()
                    })
                }
            }
        }
    }

    func submitOrder(order: Order, completion: () -> Void) {
        guard let param = order.content() else { return }
        let url = NSURL(string: (baseUrl.stringByAppendingString("orders")))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(param, options: .PrettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = manager.uploadTaskWithStreamedRequest(request, progress: nil) { (response, obj, error) in
            if error == nil {
                if let obj = obj as? [[String: AnyObject]], let id = obj[0]["order"] as? String {
                    order.id = id
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.saveContext()
                }
                completion()
            }
        }
        task.resume()
    }

    func confirmOrder(order: Order, completion: () -> Void) {
        let url = NSURL(string: ("\(baseUrl)/orders/\(order.id)"))
        let id = NSUserDefaults.standardUserDefaults().objectForKey("primaryID") as! String
        let param = ["buyer": id]
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(param, options: .PrettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = manager.uploadTaskWithStreamedRequest(request, progress: nil) { (response, obj, error) in
            if error == nil {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let context = appDelegate.managedObjectContext
                order.buyer = context.primaryUser()
                appDelegate.saveContext()
            }
            completion()
        }
        task.resume()
    }

    func fetchPrimaryUser(completion:(User -> Void)) {
        //let id = "57ef666f81e25438e97d1446"
        let id = NSUserDefaults.standardUserDefaults().objectForKey("primaryID") as! String
        return fetchUser(id, completion: completion)
    }

    func fetchUser(id: String, completion:(User -> Void)) {
        let url = NSURL(string: (baseUrl.stringByAppendingString("users/\(id)")))
        createDownloadTask(url!) { (res, obj, error) in
            if let obj = obj as? [String:AnyObject] {
                let user = RemoteUserEndPoint.parseUser(obj)
                if let user = user {
                    completion(user)
                }
            }
        }
    }

    func downloadImage(urlString: String, completion:(UIImage ->Void)) {
        let str = "http://www.xiaolongwu.com/buzznow" + urlString
        if let imgUrl = NSURL(string:str) {
            dispatch_async(imageQueue, {
                if let data = NSData(contentsOfURL: imgUrl) {
                    if let image = UIImage(data: data, scale: 1.0) {
                        completion(image)
                    }
                }
            })
        }
    }

    private func createDownloadTask(url: NSURL, completion:((NSURLResponse, AnyObject?, NSError?) -> Void)) {
        let request = NSURLRequest(URL: url)
        let downloadTask = manager.dataTaskWithRequest(request) { (res, obj, error) in
            completion(res, obj, error)
        }
        downloadTask.resume()
    }
}
