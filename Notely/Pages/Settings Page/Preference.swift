//
//  Preference.swift
//  Notely
//
//  Created by Arsha Hassas on 8/16/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import Foundation

final class Preference: NSObject {
    
    enum SortingMethod: Int, CaseIterable, Codable {
        case newestToOldest, oldestToNewest, lastUpdated
        
        var string: String {
            switch self {
            case .newestToOldest: return NSLocalizedString("Newest to Oldest", comment: "")
            case .oldestToNewest: return NSLocalizedString("Oldest to Newest", comment: "")
            case .lastUpdated: return NSLocalizedString("Last Updated", comment: "")
            }
        }
    }
    
    static let shared = Preference()
    weak var delegate: PreferenceDelegate?
    
    @UserDefault(key: "folders-sorting-methods", defaultValue: Preference.SortingMethod.newestToOldest)
    var foldersSortingMethod { didSet { self.signal() }}
    
    @UserDefault(key: "notes-sorting-methods", defaultValue: Preference.SortingMethod.newestToOldest)
    var notesSortingMethod { didSet { self.signal() }}
    
    private func signal() {
        NotificationCenter.default.post(name: .preferenceDidChange, object: self)
        delegate?.preferenceDidChange(self)
    }
}

protocol PreferenceDelegate: AnyObject {
    func preferenceDidChange(_ preference: Preference)
}

extension Notification.Name {
    static let preferenceDidChange = Notification.Name("preference-did-change")
}
