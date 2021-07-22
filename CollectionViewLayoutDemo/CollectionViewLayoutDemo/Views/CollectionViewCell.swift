//
//  CollectionViewCell.swift
//  CollectionViewLayoutDemo
//
//  Created by darkgm on 2021/7/20.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        contentView.addSubview(colorView)
        colorView.addSubview(textLabel)
    }
    
    private func setupConstraints() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            colorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            colorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ])
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
    }
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
}
