//
//  NormalTextFieldController.swift
//  IQKeyboardDemo
//
//  Created by darkgm on 2020/11/23.
//

import UIKit

class NormalTextFieldController: UIViewController {
    
    private let cellIdentifier = "textFieldCell"
    private var dataSource: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSubview()
        layoutSubview()
        loadData()
    }
    
    private func loadData() {
        dataSource = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N"]
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
        view.register(TextFieldCell.self, forCellReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()

}

extension NormalTextFieldController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TextFieldCell
        cell.title = dataSource[indexPath.row]
        cell.placeholder = "请输入\(dataSource[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
