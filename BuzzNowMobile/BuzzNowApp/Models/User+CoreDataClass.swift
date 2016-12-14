//
//  User+CoreDataClass.swift
//  
//
//  Created by Shawn Wu on 11/8/16.
//
//

import Foundation
import CoreData

public class User: NSManagedObject {
    func content() -> [String: AnyObject]? {
        guard let name = self.name, let email = self.email, let address = address else { return nil }
        return ["name": name, "email": email, "address": address]
    }
}
