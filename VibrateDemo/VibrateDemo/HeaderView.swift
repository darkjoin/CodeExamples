//
//  HeaderView.swift
//  VibrateDemo
//
//  Created by darkgm on 2020/12/11.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    var haederTitle: String? {
        willSet {
            label.text = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        layoutSubview()
    }
    
    private func addSubview() {
        addSubview(label)
    }
    
    private func layoutSubview() {
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
}
