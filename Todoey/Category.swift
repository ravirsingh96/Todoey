//
//  Category.swift
//  Todoey
//
//  Created by ravi singh on 15/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color: String = ""
    let Items = List<Item> ()
    
    
}
