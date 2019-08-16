//
//  FolderViewController.swift
//  Notely
//
//  Created by Arsha Hassas on 8/1/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit


final class FolderViewController: UITableViewController, Storyboarded {
    static let cellIdentifier = "basic-cell"
    
    weak var coordinator: MainCoordinator?
    
    private var persistentManager = PersistentManager(of: Folder.self)
    private var dataSource: ObjectDataSource<Folder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBarButtons()
        
        self.dataSource = ObjectDataSource(tableView: self.tableView,
                                                         cellID: FolderViewController.cellIdentifier,
                                                         data: persistentManager.all().sorted(byKeyPath: "timestamp", ascending: false),
                                                         cellConfigBlock: cellProvider(cell:folder:)) 
    }
    
    private func cellProvider(cell: UITableViewCell, folder: Folder) {
        cell.textLabel?.text = folder.name
    }
    
    private func addBarButtons() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addFolder(_:)))
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
                                                let folder = self.dataSource.object(at: indexPath)
                                                self.persistentManager.delete(folder)
                                                completed(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = dataSource.object(at: indexPath)
        coordinator?.open(folder)
    }
    
}



