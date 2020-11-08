//
//  ViewController.swift
//  WatermarkDemo
//
//  Created by darkgm on 2020/11/6.
//

import UIKit

class ViewController: UIViewController {
    
    private let cellIdentifier = "cell"
    private var items: [[String: Any]] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WatermarkDemo"
        loadSubview()
        layoutSubview()
        loadData()
    }
    
    private func loadData() {
        items = [
            ["id": "textWatermarkOnImage", "title": "图片上添加文字水印"],
            ["id": "textWatermarkOnVideo", "title": "视频上添加文字水印"],
            ["id": "textWatermarkOnWebview", "title": "网页上添加文字水印"],
            ["id": "patternWatermarkOnWebview", "title": "网页上添加图案水印"]
        ]
    }

    private func loadSubview() {
        view.addSubview(tableView)
    }
    
    private func layoutSubview() {
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item["title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var viewController: UIViewController?
        if let id = items[indexPath.row]["id"] as? String {
            switch id {
            case "textWatermarkOnImage":
                viewController = ImageWatermarkViewController()
            case "textWatermarkOnVideo":
                viewController = VideoWatermarkViewController()
            case "textWatermarkOnWebview":
                viewController = WebTextWatermarkViewController()
            case "patternWatermarkOnWebview":
                viewController = WebPatternWatermarkViewController()
            default:
                break
            }
        }
        guard let vc = viewController else { return }
        vc.title = items[indexPath.row]["title"] as? String
        self.show(vc, sender: self)
    }
}

