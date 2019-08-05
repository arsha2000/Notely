//
//  Folder.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import RealmSwift
import Foundation

@objcMembers
final class Folder: Object {
    dynamic var id = UUID().uuidString
    dynamic var name: String = ""
    
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
