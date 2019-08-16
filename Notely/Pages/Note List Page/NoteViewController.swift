//
//  NoteViewController.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit
import RealmSwift

final class NoteViewController: UITableViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    var folder: Folder!
    
    private let persistentManager = PersistentManager(of: Note.self)
    private var dataSource: ObjectDataSource<Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationItem.title = self.folder.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addNote))
        
        configDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource.reloadData(animated: false)
    }
    
    @objc private func addNote() {
        let note = Note(body: "", parent: folder)
        persistentManager.add(note)
        coordinator?.open(note)
    }

    private func configDataSource() {
        guard let folder = folder else { return }
        
        let predicate = NSPredicate(format: "parent.id == %@", folder.id)
        let results = persistentManager.all(predicate: predicate).sorted(byKeyPath: "timestamp", ascending: false)
        
        self.dataSource = ObjectDataSource<Note>(tableView: self.tableView,
                                                 cellID: "basic-cell",
                                                 data: results,
                                                 cellConfigBlock: cellProvider(_:note:))
    }
    
    private func cellProvider(_ cell: UITableViewCell, note: Note) {
        cell.textLabel?.text = note.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.dataSource.object(at: indexPath)
        coordinator?.open(note)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let note = self.dataSource.object(at: indexPath)
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completed) in
            self.persistentManager.delete(note)
            completed(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        return .init(actions: [deleteAction])
    }
}
