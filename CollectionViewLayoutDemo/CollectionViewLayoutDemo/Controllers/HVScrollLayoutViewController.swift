//
//  HVScrollLayoutViewController.swift
//  CollectionViewLayoutDemo
//
//  Created by darkgm on 2021/7/21.
//

import UIKit

class HVScrollLayoutViewController: UIViewController {
    
    let cellIdentifier = NSStringFromClass(CollectionViewCell.self)
    var dataSources: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HVScrollLayout"
        setupData()
        setupUI()
        setupConstraints()
    }
    
    private func setupData() {
        for _ in 0..<30 {
            let color = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
            dataSources.append(color)
        }
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: HVScrollLayout())
        view.backgroundColor = .white
        view.isDirectionalLockEnabled = true
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()

}

extension HVScrollLayoutViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CollectionViewCell {
            cell.colorView.backgroundColor = dataSources[indexPath.item] as? UIColor
            cell.textLabel.text = "cell-\(indexPath.section)-\(indexPath.item)"
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
