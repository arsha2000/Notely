//
//  FolderViewController.swift
//  Notely
//
//  Created by Arsha Hassas on 8/1/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit
import RealmSwift
import Combine


final class FolderViewController: UITableViewController, Storyboarded {
    static let cellIdentifier = "basic-cell"
    
    weak var coordinator: MainCoordinator?
    
    private var persistentManager = PersistentManager(of: Folder.self)
    private var dataSource: ObjectDataSource<Folder>!
    private var preferenceCancellable: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBarButtons()
        
        configDataSource()
        
        // Sort Folders accordingly when preference changes
        self.preferenceCancellable = NotificationCenter.default
            .publisher(for: .preferenceDidChange)
            .sink { _ in self.configDataSource() }
        
    }
}

// MARK: - UI Methods

extension FolderViewController {
    private func addBarButtons() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addFolder(_:)))
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

// MARK: - Data Source

extension FolderViewController {
    
    private func configDataSource() {
        self.dataSource = ObjectDataSource(tableView: self.tableView,
        cellID: FolderViewController.cellIdentifier,
        data: sortedResult(),
        cellConfigBlock: cellProvider(cell:folder:))
    }
    
    private func sortedResult() -> Results<Folder> {
        switch Preference.shared.foldersSortingMethod {
        case .newestToOldest, .lastUpdated:
            return persistentManager.all().sorted(byKeyPath: Folder.Key.timestamp, ascending: false)
        case .oldestToNewest:
            return persistentManager.all().sorted(byKeyPath: Folder.Key.timestamp, ascending: true)
        }
    }
    
    private func cellProvider(cell: UITableViewCell, folder: Folder) {
        cell.textLabel?.text = folder.name
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



