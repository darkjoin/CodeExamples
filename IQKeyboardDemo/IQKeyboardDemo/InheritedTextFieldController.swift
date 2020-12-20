//
//  InheritedTextFieldController.swift
//  IQKeyboardDemo
//
//  Created by darkgm on 2020/11/27.
//

import UIKit

class InheritedTextFieldController: UIViewController {

    private let inheritedCellIdentifier = "inheritedTextFieldCell"
    private let cellIdentifier = "textFieldCell"
    private var dataSource: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSubview()
        layoutSubview()
        loadData()
    }
    
    private func loadData() {
        dataSource = [
            ["type": inheritedCellIdentifier, "title": "A"],
            ["type": cellIdentifier, "title": "B"],
            ["type": inheritedCellIdentifier, "title": "C"],
            ["type": cellIdentifier, "title": "D"],
            ["type": inheritedCellIdentifier, "title": "E"],
            ["type": cellIdentifier, "title": "F"],
            ["type": inheritedCellIdentifier, "title": ""],
            ["type": cellIdentifier, "title": ""],
            ["type": inheritedCellIdentifier, "title": "I"],
            ["type": cellIdentifier, "title": "J"],
            ["type": inheritedCellIdentifier, "title": "K"],
            ["type": cellIdentifier, "title": "L"],
            ["type": inheritedCellIdentifier, "title": "M"],
            ["type": cellIdentifier, "title": "N"]
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
        view.register(InheritedTextFieldCell.self, forCellReuseIdentifier: inheritedCellIdentifier)
        view.register(TextFieldCell.self, forCellReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()

}

extension InheritedTextFieldController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.row]
        let type = data["type"] as? String
        let title = data["title"] as? String
        
        if type == inheritedCellIdentifier {
            let cell = tableView.dequeueReusableCell(withIdentifier: inheritedCellIdentifier, for: indexPath) as! InheritedTextFieldCell
            cell.title = title
            cell.placeholder = "请输入\(title ?? "")"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TextFieldCell
            cell.title = title
            cell.placeholder = "请输入\(title ?? "")"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
