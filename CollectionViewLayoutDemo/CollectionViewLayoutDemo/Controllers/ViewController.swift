//
//  ViewController.swift
//  CollectionViewLayoutDemo
//
//  Created by darkgm on 2021/7/17.
//

import UIKit

class ViewController: UIViewController {
    
    let cellIdentifier = NSStringFromClass(UITableViewCell.self)
    var dataSources: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CollectionViewLayoutDemo"
        setupData()
        setupUI()
        setupConstraints()
    }
    
    private func setupData() {
        dataSources = [
            ["id": "flow", "title": "FlowLayout"],
            ["id": "custom", "title": "WaterfallLayout"],
            ["id": "circle", "title": "CircleLayout"],
            ["id": "wheel", "title": "WheelLayout"],
            ["id": "hvScroll", "title": "HVScrollLayout"]
        ]
    }

    private func setupUI() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.rowHeight = 60
        view.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = dataSources[indexPath.row]["title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = dataSources[indexPath.row]["id"] as? String, !id.isEmpty else { return }
        var controller: UIViewController?
        if id == "flow" {
            controller = FlowLayoutViewController()
        } else if id == "custom" {
            controller = WaterfallLayoutViewController()
        } else if id == "circle" {
            controller = CircleLayoutViewController()
        } else if id == "wheel" {
            controller = WheelLayoutViewController()
        } else if id == "hvScroll" {
            controller = HVScrollLayoutViewController()
        }
        
        guard let controller = controller else {return }
        self.show(controller, sender: self)
    }
}




