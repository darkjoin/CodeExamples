//
//  InheritedTextFieldCell.swift
//  IQKeyboardDemo
//
//  Created by darkgm on 2020/11/23.
//

import UIKit

class InheritedTextFieldCell: TextFieldCell {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var title: String? {
        set {
            titleLabel.text = newValue
            if let emptyValue = newValue?.isEmpty, emptyValue {
                starLabel.isHidden = true
            } else {
                starLabel.isHidden = false
            }
        }
        get {
            return titleLabel.text
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        #warning("later")
        // 继承这里之前遇到一个问题：继承的cell点击keyboard上的上下不能正确定位到文本框，解决办法是继承的子类在创建UI的时候，先去父类的UI，具体问题这里忘记了没有复现出来
//        contentView.removeAllSubviews()
        
        contentView.addSubview(starLabel)
        starLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.height.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(starLabel.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.remakeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var starLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = .red
        return label
    }()

}

extension UIView {
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
