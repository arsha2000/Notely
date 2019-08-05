//
//  FolderViewControllerDataSource.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit
import RealmSwift


final class FolderViewControllerDataSource: NSObject {
    
    private let tableView: UITableView
    
    private var folderResults: Results<Folder>
    private var notificationToken: NotificationToken?
    
    func folder(at indexPath: IndexPath) -> Folder {
        return self.folderResults[indexPath.row]
    }

    init(tableView: UITableView, data: Results<Folder>) {
        self.tableView = tableView
        self.folderResults = data
        super.init()
        
        self.configDataSource()
        self.configNotification()
        
    }
}


// MARK: - Persistent Manager

extension FolderViewControllerDataSource {
    
    private func configNotification() {
        self.notificationToken = self.folderResults.observe(notificationHandler(_:))
    }
    
    private func notificationHandler(_ change: RealmCollectionChange<Results<Folder>>) {
        switch change {
        case .initial(_): break
        case .error(let error): print(error.localizedDescription)
        case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
            let toDeleteIndexPaths = deletions.map { IndexPath(row: $0, section: 0) }
            let toInsertIndexPaths = insertions.map { IndexPath(row: $0, section: 0) }
            let toModifyIndexPaths = modifications.map { IndexPath(row: $0, section: 0) }

            tableView.performBatchUpdates({
                tableView.reloadRows(at: toModifyIndexPaths, with: .automatic)
                tableView.deleteRows(at:toDeleteIndexPaths, with: .automatic)
                tableView.insertRows(at: toInsertIndexPaths, with: .automatic)
            }, completion: nil)
        }
    }
}

// MARK: - Table View Data Source

extension FolderViewControllerDataSource: UITableViewDataSource {
    
    private func configDataSource() {
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.folderResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderViewController.cellIdentifier, for: indexPath)
        let folder = self.folder(at: indexPath)
        
        cell.textLabel?.text = folder.name
        
        return cell
    }
}
