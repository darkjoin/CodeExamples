//
//  TableViewCell.swift
//  TableViewMultipleSelected
//
//  Created by darkgm on 2020/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
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
        contentView.addSubview(titleLabel)
    }
    
    private func layoutSubview() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
}
