//
//  ViewController.swift
//  RealmDemo
//
//  Created by darkgm on 2021/4/27.
// reference0: https://learnappmaking.com/realm-database-swift-getting-started/
// reference1: https://docs.mongodb.com/realm-legacy/docs/tutorials/realmtasks/
// reference2: https://docs.mongodb.com/realm-legacy/docs/swift/latest/#property-attributes
// Realm属性必须具有@objc dynamic var 属性，才能称为基础数据库数据的访问器。但是对于LinkingObjects，List和RealmOptional不能声明动态的，并且应始终使用let。

import UIKit
import RealmSwift
import SnapKit

class ViewController: UIViewController {
    
    let cellIdentifier = "cell"
    var items = List<Task>()
    var notificationToken: NotificationToken?
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupRealm()
    }
    
    private func setupUI() {
        title = "My Tasks"
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        let messageItem = UIBarButtonItem(title: "Message", style: .plain, target: self, action: #selector(showMessage))
        navigationItem.rightBarButtonItems = [addItem, messageItem]
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func setupRealm() {
        do {
            let realm = try Realm()
            self.realm = realm
        } catch {
            print(error.localizedDescription)
        }
        
        func updateList() {
            let list = self.realm.objects(Task.self)
            self.items.removeAll()
            for task in list {
                self.items.append(task)
            }
            tableView.reloadData()
        }
        updateList()
        
        // Notify us when Realm changes
        self.notificationToken = self.realm.observe({ (_, _) in
            updateList()
        })
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
}

extension ViewController {
    @objc func add() {
        let alertController = UIAlertController(title: "New Task", message: "Enter Task Name", preferredStyle: .alert)
        var alertTextField: UITextField!
        alertController.addTextField { (textField) in
            alertTextField = textField
            textField.placeholder = "Task Name"
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            guard let text = alertTextField.text, !text.isEmpty else { return }
            
            let task = Task(value: ["text": text])
            do {
                try self.realm.write {
                    self.realm.add(task)
                    self.items.append(task)
                }
            } catch {
                print(error.localizedDescription)
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func showMessage() {
        let controller = MessageViewController()
        self.show(controller, sender: self)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        let item = items[indexPath.row]
        cell.textLabel?.text = item.text
        cell.textLabel?.alpha = item.completed ? 0.5 : 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = realm.objects(Task.self)[indexPath.row]
        try! self.realm?.write {
            item.completed = !item.completed
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = realm.objects(Task.self)[indexPath.row]
            try! self.realm.write {
                realm.delete(item)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}


final class Task: Object {
    @objc dynamic var text = ""
    @objc dynamic var completed = false
}






