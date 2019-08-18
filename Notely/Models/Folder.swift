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
final class Folder: Object, Identifiable {
    dynamic var id = UUID().uuidString
    dynamic var name: String = ""
    dynamic var timestamp = Date()
    let notes = List<Note>()
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Folder {
    enum Key {
        static let id = "id"
        static let name = "name"
        static let timestamp = "timestamp"
        static let notes = "notes"
    }
}

#if DEBUG
var sampleFolder: Folder = {
    let folder = Folder(name: "Sample Folder")
    let sampleNote = Note(body: "Sample Sample", parent: folder)
    folder.notes.append(sampleNote)
    return folder
}()
#endif
