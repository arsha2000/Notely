//
//  Coordinator.swift
//  Notely
//
//  Created by Arsha Hassas on 8/1/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childrenCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
