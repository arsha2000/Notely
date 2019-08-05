//
//  MainCoordinator.swift
//  Notely
//
//  Created by Arsha Hassas on 8/1/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

final class MainCoordinator: Coordinator {
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childrenCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    func start() {
        let vc = FolderViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func open(_ folder: Folder) {
        let noteList = NotesList()
        let vc = UIHostingController(rootView: noteList)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
