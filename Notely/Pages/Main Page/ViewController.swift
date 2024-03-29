//
//  FolderViewController.swift
//  Notely
//
//  Created by Arsha Hassas on 8/1/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit
import RealmSwift


final class FolderViewController: UITableViewController, Storyboarded {
    static let cellIdentifier = "basic-cell"
    
    weak var coordinator: MainCoordinator?
    private var persistentManager = PersistentManager(of: Folder.self)
    private var dataSource: FolderViewControllerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBarButtons()
        self.dataSource = FolderViewControllerDataSource(tableView: self.tableView,
                                                         cellID: FolderViewController.cellIdentifier,
                                                         data: persistentManager.all())
    }
    
    private func addBarButtons() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolder(_:)))
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @objc private func addFolder(_ sender: UIBarButtonItem) {
        self.present(alert(), animated: true)
    }
    
    private func alert() -> UIAlertController {
        return UIAlertController.alertWithTextField(title: "New Folder", message: nil, textFieldPlaceholder: "Name") { (folderName) in
            let folder = Folder(name: folderName)
            self.persistentManager.add(folder)
        }
    }
}


// MARK: - Table View Delegate

extension FolderViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: nil) { (_, _, completed) in
                                                let folder = self.dataSource.folder(at: indexPath)
                                                self.persistentManager.delete(folder)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = dataSource.folder(at: indexPath)
        coordinator?.open(folder)
    }
    
}



