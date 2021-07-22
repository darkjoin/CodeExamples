//
//  CircleLayout.swift
//  CollectionViewLayoutDemo
//
//  Created by darkgm on 2021/7/21.
//
// 参考：https://augmentedcode.io/2019/01/20/circle-shaped-collection-view-layout-on-ios/

import UIKit

class CircleLayout: UICollectionViewLayout {
    
    private var layoutCircleFrame = CGRect.zero
    private let layoutInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    private let itemSize = CGSize(width: 100, height: 100)
    private var itemLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // 设置contentSize
    override var collectionViewContentSize: CGSize {
        return collectionView?.bounds.size ?? .zero
    }
    
    // bounds改变的时候重置layout（比如旋转设备）
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // 提前计算cell位置，当collectionView第一次出现在屏幕以及布局无效时会调用prepare方法
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        itemLayoutAttributes.removeAll()
        
        layoutCircleFrame = CGRect(origin: .zero, size: collectionViewContentSize).inset(by: layoutInsets).insetBy(dx: itemSize.width / 2.0, dy: itemSize.height / 2.0).offsetBy(dx: collectionView.contentOffset.x, dy: collectionView.contentOffset.y).insetBy(dx: -collectionView.contentOffset.x, dy: -collectionView.contentOffset.y)
        
        for section in 0..<collectionView.numberOfSections {
            switch section {
            case 0:
                let itemCount = collectionView.numberOfItems(inSection: section)
                itemLayoutAttributes = (0..<itemCount).map({ (index) -> UICollectionViewLayoutAttributes in
                    let angleStep: CGFloat = 2.0 * CGFloat.pi / CGFloat(itemCount)
                    var position = layoutCircleFrame.center
                    position.x += layoutCircleFrame.size.innerRadius * cos(angleStep * CGFloat(index))
                    position.y += layoutCircleFrame.size.innerRadius * sin(angleStep * CGFloat(index))
                    let indexPath = IndexPath(item: index, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = CGRect(center: position, size: itemSize)
                    return attributes
                })
            default:
                fatalError("Unhandled section \(section).")
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let numberOfItems = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
        guard numberOfItems > 0 else { return nil }
        switch indexPath.section {
        case 0:
            return itemLayoutAttributes[indexPath.item]
        default:
            fatalError("Unknown section \(indexPath.section)")
        }
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0, width: size.width, height: size.height)
    }
    
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}

extension CGSize {
    var innerRadius: CGFloat { return min(width, height) / 2.0 }
}
