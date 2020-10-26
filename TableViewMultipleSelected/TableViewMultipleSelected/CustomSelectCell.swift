//
//  CustomSelectCell.swift
//  TableViewMultipleSelected
//
//  Created by darkgm on 2020/10/26.
//

import UIKit

class CustomSelectCell: UITableViewCell {

    var isEditMode = false {
        didSet {
            selectIconView.isHidden = !isEditMode
            
            if isEditMode {
                titleLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(10)
                    make.left.equalTo(selectIconView.snp.right).offset(10)
                    make.bottom.equalTo(-10)
                }
            } else {
                titleLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(10)
                    make.left.equalTo(10)
                    make.bottom.equalTo(-10)
                }
            }
        }
    }
    
    var isSelectedCell = false {
        didSet {
            let imageName = isSelectedCell ? "message_select" : "message_unselect"
            selectIconView.image = UIImage(named: imageName)
        }
    }
    
    var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        loadSubview()
        layoutSubview()
    }
    
    private func loadSubview() {
        contentView.addSubview(selectIconView)
        contentView.addSubview(titleLabel)
    }
    
    private func layoutSubview() {
        selectIconView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(selectIconView.snp.right).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var selectIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "message_unselect")
        imageView.clipsToBounds = true
        return imageView
    }()

}
