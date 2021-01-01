//
//  HapticsViewController.swift
//  VibrateDemo
//
//  Created by darkgm on 2020/12/9.
//

import UIKit
import AudioToolbox

class HapticsViewController: UIViewController {
    
    private enum Section: Int, CaseIterable {
        case impact
        case notification
        case selection
        
        var toString: String {
            switch self {
            case .impact: return "Impact"
            case .notification: return "Notification"
            case .selection: return "Selection"
            }
        }
    }
    
    private enum FeedbackGenerator {
        case impact(UIImpactFeedbackGenerator.FeedbackStyle)
        case notification(UINotificationFeedbackGenerator.FeedbackType)
        case selection
        
        var toString: String {
            switch self {
            case .impact(let feedbackStyle):
                switch feedbackStyle {
                case .heavy: return "heavy"
                case .light: return "light"
                case .medium: return "medium"
                case .rigid: return "rigid"
                case .soft: return "soft"
                @unknown default: return "unknown"
                }
            case .notification(let feedbackType):
                switch feedbackType {
                case .error: return "error"
                case .success: return "success"
                case .warning: return "warning"
                @unknown default: return "unknown"
                }
            case .selection: return "selection"
            }
        }
    }
    
    private let headerIdentifier = "Header"
    private let footerIdentifier = "footer"
    private let cellIdentifier = "CollectionCell"
    private var dataSource: [Section: [FeedbackGenerator]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Haptics"
        view.backgroundColor = .white
        loadSubview()
        layoutSubview()
        loadData()
    }
    
    private func loadData() {
        dataSource = [
            .impact: [
                .impact(.heavy),
                .impact(.light),
                .impact(.medium),
                .impact(.rigid),
                .impact(.soft)
            ],
            .notification: [
                .notification(.error),
                .notification(.success),
                .notification(.warning)
            ],
            .selection: [
                .selection
            ]
        ]
    }
    
    private func generateFeedBack(for feedbackGenerator: FeedbackGenerator) {
        switch feedbackGenerator {
        case .impact(let feedbackStyle):
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
            impactFeedbackGenerator.impactOccurred()
        case .notification(let feedbackType):
            let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator.notificationOccurred(feedbackType)
        case .selection:
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
    
    private func loadSubview() {
        view.addSubview(collectionView)
    }
    
    private func layoutSubview() {
        collectionView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.register(CollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()

}

extension HapticsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section), let items = dataSource[section]  else {
            fatalError("Invalid Section")
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = Section(rawValue: indexPath.section), let feedbackGenerator = dataSource[section] else {
            fatalError("Invalid Section")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionCell
        cell.title = feedbackGenerator[indexPath.item].toString
        cell.cornerRadius = 15
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section), let feedbackGenerator = dataSource[section] else {
            fatalError("Invalid Section")
        }
        generateFeedBack(for: feedbackGenerator[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Invalid Section")
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! HeaderView
            headerView.haederTitle = section.toString
            return headerView
        } else {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath)
            return footerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 20)
    }
}
