//
//  MainTableViewController.swift
//  TableViewMultipleSelected
//
//  Created by darkgm on 2020/10/23.
//

import UIKit
import SnapKit

class MainTableViewController: UIViewController {
    
    var itemSources: [String] = []
    var selectedItems: [String] = []
    let cellIdentifier = "cell"
    var isEditMode = false {
        didSet {
            if let rightButtonItem = navigationItem.rightBarButtonItem {
                rightButtonItem.title = isEditMode ? "取消" : "编辑"
            }
            tableView.isEditing = isEditMode
            tableView.allowsMultipleSelectionDuringEditing = tableView.isEditing
            bottomToolBar.isHidden = !isEditMode
            selectedItems.removeAll()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SystemMultipleSelected"
        createRightButtonWithTitle("编辑", target: self)
        createLeftButtonWithTitle("添加数据", target: self)
        loadSubview()
        layoutSubview()
    }
    
    private func loadSubview() {
        view.addSubview(tableView)
        view.addSubview(bottomToolBar)
    }
    
    
    private func layoutSubview() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bottomToolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom)
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var bottomToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.isHidden = true
        toolBar.barStyle = .default
        let flexibleButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([selectAllButtonItem, flexibleButtonItem, deleteButtonItem], animated: true)
        return toolBar
    }()
    
    lazy var selectAllButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "全选", style: .plain, target: self, action: #selector(selectAllItem(_:)))
        return buttonItem
    }()
    
    lazy var deleteButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "删除", style: .plain, target: self, action: #selector(deleteItem(_:)))
        return buttonItem
    }()
}

// MARK: Actions
extension MainTableViewController {
    // 添加数据
    @objc private func onLeftButtonClick(_ button: UIBarButtonItem) {
        for _ in 0...10 {
            let string = self.randomString(length: 8)
            itemSources.append(string)
        }
        selectedItems.removeAll()
        tableView.reloadData()
    }
    
    // 编辑/取消
    @objc private func onRightButtonClick(_ button: UIBarButtonItem) {
        isEditMode = !isEditMode
    }
    
    // 全选操作
    @objc private func selectAllItem(_ buttonItem: UIBarButtonItem) {
        self.selectedItems.removeAll()
        for row in 0..<itemSources.count {
            let indexPath = IndexPath(row: row, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            #warning("去除选中状态会使取消选中失效")
//            if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
//                cell.selectionStyle = .none
//            }
        }
        selectedItems = itemSources
        print("selectedItems: \(selectedItems)")
        print("itemSources: \(itemSources)")
    }

    // 删除操作
    @objc private func deleteItem(_ buttonItem: UIBarButtonItem) {
        itemSources.removeAll(where: {self.selectedItems.contains($0)})
        selectedItems.removeAll()
        tableView.reloadData()
        print("selectedItems: \(selectedItems)")
        print("itemSources: \(itemSources)")
    }
    
    // 选中/取消选中时执行的操作
    private func selectDeselectCell(tableView: UITableView, indexPath: IndexPath) {
        selectedItems.removeAll()
        if let array = tableView.indexPathsForSelectedRows {
            for indexPath in array {
                let string = itemSources[indexPath.row]
                selectedItems.append(string)
            }
        }
        print(selectedItems)
        
        #warning("去除选中状态会使取消选中失效")
//        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
//            cell.selectionStyle = .none
//        }
    }
    
    // 获取指定长度的随机字符串
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

// MARK: BarButtonItems
extension MainTableViewController {
    
    private func createLeftButtonWithTitle(_ title: String, target: Any?) {
        let leftButtonItem = UIBarButtonItem(title: title, style: .plain, target: target, action: #selector(onLeftButtonClick(_:)))
        leftButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        leftButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .highlighted)
        self.navigationItem.leftBarButtonItem = leftButtonItem
    }

    private func createRightButtonWithTitle(_ title: String, target: Any?) {
        let rightButtonItem = UIBarButtonItem(title: title, style: .plain, target: target, action: #selector(onRightButtonClick(_:)))
        rightButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        rightButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .highlighted)
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension MainTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        cell.title = itemSources[indexPath.row]
        cell.tintColor = .systemYellow
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectDeselectCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectDeselectCell(tableView: tableView, indexPath: indexPath)
    }
}
