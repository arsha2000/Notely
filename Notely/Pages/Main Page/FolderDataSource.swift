//
//  FolderDataSource.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit
import RealmSwift


final class FolderDataSource {
    
    private let tableView: UITableView
    private let cellID: String
    
    private enum Section { case main }
    private typealias FolderID = String
    private var dataSource: UITableViewDiffableDataSource<Section, FolderID>!
    
    private var folderResults: Results<Folder>
    private var notificationToken: NotificationToken?
    
    func folder(at indexPath: IndexPath) -> Folder {
        return self.folderResults[indexPath.row]
    }

    init(tableView: UITableView, cellID: String, data: Results<Folder>) {
        
        
        self.configDataSource()
        self.configNotification()
        self.reloadData(animated: false)
        
    }
}


// MARK: - Persistent Manager

extension FolderDataSource {
    
    private func configNotification() {
        self.notificationToken = self.folderResults.observe(notificationHandler(_:))
    }
    
    private func notificationHandler(_ change: RealmCollectionChange<Results<Folder>>) {
        switch change {
        case .initial(_): break
        case .update(_, deletions: _, insertions: _ , modifications: _): self.reloadData(animated: true)
        case .error(let error): print(error.localizedDescription)
        }
    }
}

// MARK: - Table View Data Source

extension FolderDataSource {
    
    private func configDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: self.tableView, cellProvider: cellProvider)
    }
    
    private func cellProvider(tableView: UITableView, indexPath: IndexPath, folderID: FolderID) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        guard let fol = folderResults.first(where: { $0.id == folderID }) else { return nil }
        
        cell.textLabel?.text = fol.name
        
        return cell
    }
    
    private func reloadData(animated: Bool) {
        
        let folderIDs: [FolderID] = folderResults.map { $0.id }

        let snapshot = NSDiffableDataSourceSnapshot<Section, FolderID>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(folderIDs)
        
        self.dataSource.apply(snapshot)
    }
}
