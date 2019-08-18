//
//  ObjectDataSource.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit
import RealmSwift

@available(iOS 13, *)
final class ObjectDataSource<ObjectType: Object & Identifiable> {
    
    private typealias ObjectID = ObjectType.ID
    
    private let tableView: UITableView
    private let cellID: String
    private var cellConfigBlock: ((UITableViewCell, ObjectType) -> ())
    
    private enum Section { case main }
    private var dataSource: UITableViewDiffableDataSource<Section, ObjectID>!
    
    private var objectResults: Results<ObjectType>
    private var notificationToken: NotificationToken?
    
    init(tableView: UITableView, cellID: String, data: Results<ObjectType>, cellConfigBlock: @escaping (UITableViewCell, ObjectType) -> ()) {
        self.tableView = tableView
        self.objectResults = data
        self.cellID = cellID
        self.cellConfigBlock = cellConfigBlock
        
        configNotification()
        configDataSource()
        reloadData(animated: false)
    }
    
    func object(at indexPath: IndexPath) -> ObjectType {
        return self.objectResults[indexPath.row]
    }
    
}

// MARK: - Persistent Manager

extension ObjectDataSource {
    
    private func configNotification() {
        self.notificationToken = self.objectResults.observe(notificationHandler(_:))
    }
    
    private func notificationHandler(_ change: RealmCollectionChange<Results<ObjectType>>) {
        switch change {
        case .initial(_): break
        case .update(_, deletions: _, insertions: _ , modifications: _): self.reloadData(animated: true)
        case .error(let error): print(error.localizedDescription)
        }
    }
}


// MARK: - Data Source

extension ObjectDataSource {
    
    private func configDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: self.tableView, cellProvider: cellProvider)
    }
    
    private func cellProvider(tableView: UITableView, indexPath: IndexPath, objectID: ObjectID) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let object = self.object(at: indexPath)
        
        self.cellConfigBlock(cell, object)
        
        return cell
    }
    
    func reloadData(animated: Bool) {
        
        let objectIDs: [ObjectID] = objectResults.map { $0.id }
        
        let snapshot = NSDiffableDataSourceSnapshot<Section, ObjectID>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(objectIDs)
        
        self.dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    
}
