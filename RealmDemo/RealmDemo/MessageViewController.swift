//
//  SecondViewController.swift
//  RealmDemo
//
//  Created by darkgm on 2021/4/28.
// reference: https://docs.mongodb.com/realm-legacy/docs/swift/latest/index.html#json

import UIKit
import RealmSwift

class MessageViewController: UIViewController {
    
    let cellIdentifier = "messageCell"
    var dataSources: [Any] = []
    var notificationToken: NotificationToken?
    
    let messageData = """
    {
      "data": [
        {
          "msg_id": "1619091391100008283786",
          "title": "This is a test message aaa",
          "push_time": "1619091391",
          "read_state": "0"
        },
        {
          "msg_id": "1619012020100006258084",
          "title": "This is a test message aab",
          "push_time": "1619012020",
          "read_state": "0"
        },
        {
          "msg_id": "1618500611100007710791",
          "title": "This is a test message aac",
          "push_time": "1618500611",
          "read_state": "1"
        },
        {
          "msg_id": "1618500541100009813777",
          "title": "This is a test message aad",
          "push_time": "1618500541",
          "read_state": "0"
        },
        {
          "msg_id": "1618500525100002805338",
          "title": "This is a test message aae",
          "push_time": "1618500525",
          "read_state": "0"
        },
        {
          "msg_id": "1618500408100003328991",
          "title": "This is a test message aaf",
          "push_time": "1618500408",
          "read_state": "0"
        },
        {
          "msg_id": "1618476012100004466636",
          "title": "This is a test message aag",
          "push_time": "1618476012",
          "read_state": "0"
        },
        {
          "msg_id": "1618475895100002141641",
          "title": "This is a test message aah",
          "push_time": "1618475895",
          "read_state": "0"
        },
        {
          "msg_id": "1618475868100005576825",
          "title": "This is a test message aai",
          "push_time": "1618475868",
          "read_state": "0"
        },
        {
          "msg_id": "1618466548100008642109",
          "title": "This is a test message aaj",
          "push_time": "1618466548",
          "read_state": "0"
        }
      ]
    }
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
        
        // Notify us when Realm changes
        self.notificationToken = RealmManage.shared.realm.observe({ [weak self] (_, _) in
            self?.tableView.reloadData()
        })
    }
    
    deinit {
        notificationToken?.invalidate()
    }

    private func setupUI() {
        title = "Messages"
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addData))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearData))
        navigationItem.rightBarButtonItems = [addItem, deleteItem]
    }
    
    private func setupData() {
        let data = messageData.data(using: .utf8)!
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                guard let messageInfos = json["data"] as? [[String : Any]] else { return }
                for messageInfo in messageInfos {
                    if let messageModel = MessageModel(userInfo: messageInfo) {
                        self.dataSources.append(messageModel)
                        
                        // save data with realm
                        let realmMessageModel = RealmMessageModel()
                        realmMessageModel.ID = messageModel.ID
                        realmMessageModel.title = messageModel.title
                        realmMessageModel.pushTime = messageModel.pushTime
                        realmMessageModel.pushTimeinterval = messageModel.pushTimeinterval
                        realmMessageModel.pushDate = messageModel.pushDate
                        realmMessageModel.isRead = messageModel.isRead
                        RealmManage.shared.addModel(model: realmMessageModel)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func addData() {
        setupData()
    }
    
    @objc private func clearData() {
        RealmManage.shared.deleteModelList(model: RealmMessageModel())
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSources.count
        
        return RealmManage.shared.queryModel(model: RealmMessageModel()).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageCell
//        let model = dataSources[indexPath.row] as? MessageModel
//        cell.model = model
        
        let realmModel = RealmManage.shared.queryModel(model: RealmMessageModel())[indexPath.row]
        cell.realmModel = realmModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class MessageCell: UITableViewCell {

    private let unreadColor = UIColor.black
    private let readColor = UIColor(white: 0.8, alpha: 1.0)
    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    public var model: MessageModel? {
        didSet {
            if let newModel = model {
                self.titleLabel.text = newModel.title
                self.timeLabel.text = newModel.pushTime
                
                if newModel.isRead {
                    self.titleLabel.textColor = readColor
                    self.timeLabel.textColor = readColor
                }else {
                    self.titleLabel.textColor = unreadColor
                    self.timeLabel.textColor = unreadColor
                }
            }
        }
    }
    
    public var realmModel: RealmMessageModel? {
        didSet {
            if let newModel = realmModel {
                self.titleLabel.text = newModel.title
                self.timeLabel.text = newModel.pushTime
                
                if newModel.isRead {
                    self.titleLabel.textColor = readColor
                    self.timeLabel.textColor = readColor
                }else {
                    self.titleLabel.textColor = unreadColor
                    self.timeLabel.textColor = unreadColor
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .default
        
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.text = ""
        self.titleLabel.textColor = unreadColor
        self.contentView.addSubview(self.titleLabel)
        
        self.timeLabel = UILabel()
        self.timeLabel.font = UIFont.systemFont(ofSize: 13)
        self.timeLabel.text = ""
        self.timeLabel.textColor = unreadColor
        self.contentView.addSubview(self.timeLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.height.equalTo(15)
            make.right.lessThanOrEqualTo(-15)
        }
        
        self.timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            make.left.equalTo(self.titleLabel)
            make.right.lessThanOrEqualTo(-15)
            make.height.equalTo(15)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}




