//
//  ViewController.swift
//  IQKeyboardDemo
//
//  Created by darkgm on 2020/11/18.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let cellIdentifier = "cell"
    private var dataSource: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "IQKeyboardDemo"
        loadSubview()
        layoutSubview()
        loadData()
    }
    
    private func loadData() {
        dataSource = [
            ["id":"normalTextField", "title":"普通文本框"],
            ["id":"inheritedTextField", "title":"继承的文本框"],
            ["id":"groupTextField", "title":"分组文本框"],
            ["id":"textView", "title":"文本视图"]
        ]
    }

    private func loadSubview() {
        view.addSubview(tableView)
    }
    
    private func layoutSubview() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]["title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = dataSource[indexPath.row]["id"] as? String
        let title = dataSource[indexPath.row]["title"] as? String
        let controller: UIViewController?
        switch id {
        case "normalTextField":
            controller = NormalTextFieldController()
        case "inheritedTextField":
            controller = InheritedTextFieldController()
        case "groupTextField":
            controller = GroupTextFieldViewController()
        case "textView":
            controller = TextViewController()
        default:
            return
        }
        
        guard let vc = controller else { return }
        vc.title = title
        show(vc, sender: self)
    }
}

