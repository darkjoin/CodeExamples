//
//  WheelLayout.swift
//  CollectionViewLayoutDemo
//
//  Created by darkgm on 2021/7/21.
//
// 参考：https://www.raywenderlich.com/1702-uicollectionview-custom-layout-tutorial-a-spinning-wheel

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    // 旋转是围绕anchorPoint发生的
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}

class WheelLayout: UICollectionViewLayout {
    let itemSize = CGSize(width: 133, height: 173)
    var angleAtExtreme: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    var angle: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return angleAtExtreme * collectionView.contentOffset.x / (collectionViewContentSize.width - collectionView.bounds.width)
    }
    var radius: CGFloat = 500 {
        didSet {
            invalidateLayout()
        }
    }
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    
    // 设置contentSize
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero}
        let contentWidth = itemSize.width * CGFloat(collectionView.numberOfItems(inSection: 0))
        return CGSize(width: contentWidth, height: collectionView.bounds.height)
    }
    
    // 告诉collectionView使用CircularCollectionViewLayoutAttributes作为layout attributes
    override class var layoutAttributesClass: AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2.0
        let anchorPointY = (itemSize.height / 2.0 + radius) / itemSize.height
        let theta = atan2(collectionView.bounds.width / 2.0, radius + (itemSize.height / 2.0) - collectionView.bounds.height / 2.0)
        var startIndex = 0
        var endIndex = collectionView.numberOfItems(inSection: 0) - 1
        if angle < -theta {
            startIndex = Int(floor((-theta - angle) / anglePerItem))
        }
        endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
        if endIndex < startIndex {
            endIndex = 0
            startIndex = 0
        }
//        attributesList = (0..<collectionView.numberOfItems(inSection: 0)).map({ i -> CircularCollectionViewLayoutAttributes in
//            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
//            attributes.size = self.itemSize
//            attributes.center = CGPoint(x: centerX, y: collectionView.bounds.midY)
////            attributes.angle = self.anglePerItem * CGFloat(i)
//            attributes.angle = self.angle + self.anglePerItem * CGFloat(i)
//            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
//            return attributes
//        })
        // 优化（对于屏幕外的item，跳过计算，不创建布局属性）
        attributesList = (startIndex...endIndex).map({ i -> CircularCollectionViewLayoutAttributes in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = self.itemSize
            attributes.center = CGPoint(x: centerX, y: collectionView.bounds.midY)
//            attributes.angle = self.anglePerItem * CGFloat(i)
            attributes.angle = self.angle + self.anglePerItem * CGFloat(i)
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        })
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.item]
    }
    
    // 用于调整滚动的停止位置（比如滚动停止后让item在可见区域正中间）
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme / (collectionViewContentSize.width - collectionView.bounds.width)
        let proposedAngle = proposedContentOffset.x * factor
        let ratio = proposedAngle / anglePerItem
        var multiplier: CGFloat
        if velocity.x > 0 {
            multiplier = ceil(ratio)
        } else if velocity.x < 0 {
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        finalContentOffset.x = multiplier * anglePerItem / factor
        return finalContentOffset
    }
}


