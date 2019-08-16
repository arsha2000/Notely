//
//  MainCoordinator.swift
//  Notely
//
//  Created by Arsha Hassas on 8/1/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit
import SwiftUI
import RealmSwift

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
        let vc = NoteViewController.instantiate()
        vc.folder = folder
        vc.coordinator = self
        
        vc.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func open(_ note: Note) {
        let view = NoteEditorView(model: .init(note: note))
        let vc = UIHostingController(rootView: view)
        
        vc.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(vc, animated: true)
    }
}
