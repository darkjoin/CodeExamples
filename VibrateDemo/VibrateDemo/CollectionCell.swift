//
//  CollectionCell.swift
//  VibrateDemo
//
//  Created by darkgm on 2020/12/10.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    public var title: String? {
        willSet {
            label.text = newValue
        }
    }
    
    public var cornerRadius: CGFloat = 0.0 {
        willSet {
            label.layer.cornerRadius = newValue
        }
    }
    
    public override var isSelected: Bool {
        willSet {
            if newValue {
                label.backgroundColor = .green
            } else {
                label.backgroundColor = .white
            }
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
        contentView.addSubview(label)
    }
    
    private func layoutSubview() {
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.green.cgColor
        label.layer.masksToBounds = true
        return label
    }()
}
