//
//  PersistentManager.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import RealmSwift
import CoreData

final class PersistentManager<ObjectType: Object> {
    
    private let realm: Realm
    
    init(of type: ObjectType.Type, realm: Realm? = nil) {
        if let realm = realm {
            self.realm = realm
        } else {
            var config = Realm.Configuration()
            #if DEBUG
            config.deleteRealmIfMigrationNeeded = true
            #endif
            let _realm = try! Realm(configuration: config)
            self.realm = _realm
        }
    }
    
    func all() -> Results<ObjectType> {
        return realm.objects(ObjectType.self)
    }
    
    func all(predicate: NSPredicate) -> Results<ObjectType> {
        return self.all().filter(predicate)
    }
    
    func add(_ object: ObjectType) {
        self.safeWrite {
            self.realm.add(object, update: .modified)
        }
    }
    
    func delete(_ object: ObjectType) {
        self.safeWrite {
            self.realm.delete(object)
        }
    }
    
    func modify(_ object: ObjectType, modifierBlock: @escaping (ObjectType) -> ()) {
        self.safeWrite {
            modifierBlock(object)
        }
    }
    
    private func safeWrite(_ block: @escaping () throws -> ()) {
        do {
            try realm.write {
                try block()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
