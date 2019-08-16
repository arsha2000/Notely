//
//  Note.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import RealmSwift
import Foundation

@objcMembers
final class Note: Object, Identifiable {
    
    dynamic var id = UUID().uuidString
    dynamic var body: String = ""
    dynamic var timestamp = Date()
    dynamic var parent: Folder?
    
    var title: String {
        let firstLine = body.firstLine()
        
        return firstLine.isEmpty ? "Untitled" : firstLine
        
    }
    
    convenience init(body: String, parent: Folder) {
        self.init()
        self.body = body
        self.parent = parent
    }
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
