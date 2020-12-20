//
//  TextFieldCell.swift
//  IQKeyboardDemo
//
//  Created by darkgm on 2020/11/23.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    public var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    public var placeholder: String? {
        willSet {
            textField.placeholder = newValue
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
        contentView.addSubview(textField)
    }
    
    private func layoutSubview() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(-10)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy var textField: UITextField = {
        let control = UITextField()
        control.borderStyle = .roundedRect
        control.clearButtonMode = .whileEditing
        control.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return control
    }()

}
