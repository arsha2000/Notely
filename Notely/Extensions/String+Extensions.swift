//
//  String+Extensions.swift
//  Notely
//
//  Created by Arsha Hassas on 8/6/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import Foundation

extension String {
    public func firstLine() -> String {
        guard let index = self.firstIndex(of: "\n") else { return self }
        return String(self.prefix(upTo: index))
    }
}
