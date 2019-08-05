//
//  UIStroryboard+Extension.swift
//  Notely
//
//  Created by Arsha Hassas on 8/1/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit

extension UIStoryboard {
    typealias Identifier = String
    func instantiate<T: UIViewController>(with identifier: Identifier, as type: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: identifier) as! T
    }
}


