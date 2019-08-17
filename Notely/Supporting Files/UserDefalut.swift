//
//  UserDefalut.swift
//  Notely
//
//  Created by Arsha Hassas on 8/17/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    
    let key: String
    let defaultValue: T
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.data(forKey: key) {
                return (try? decoder.decode(T.self, from: data)) ?? defaultValue
            } else {
                return defaultValue
            }
        }
        set {
            do {
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
}
