//
//  Item.swift
//  Todoey
//
//  Created by ravi singh on 15/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "Items")
}
