//
//  WaterfallLayout.swift
//  CollectionViewLayoutDemo
//
//  Created by darkgm on 2021/7/20.
//
// 参考：https://www.raywenderlich.com/4829472-uicollectionview-custom-layout-tutorial-pinterest

import UIKit

class WaterfallLayout: UICollectionViewLayout {
    
    /// 列数
    private let numberOfColumns = 2
    
    /// cell间距
    private let cellPadding: CGFloat = 6
    
    /// 内容高度
    private var contentHeight: CGFloat = 0
    
    /// 内容宽度
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    /// 保存布局信息
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    
    /// 设置collectionView的contentSize（需要返回所有内容的宽高，collectionView使用此信息来配置自己的内容大小以方便滚动）
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    /// 设置布局信息（在开始布局和布局失效后重新布局都会调用该方法）
    override func prepare() {
//        super.prepare()
        
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        // 计算列的宽度
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        // 计算每个item的x坐标
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        // 初始化column的索引
        var column = 0
        // 初始化item的y坐标
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        // 遍历item
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            // 获取item的实际高度
            let randomHeight = CGFloat(100 + arc4random_uniform(200))
            let height = cellPadding * 2 + randomHeight
            // 设置item的frame
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            // 计算collectionView的内容高度
            contentHeight = max(contentHeight, frame.maxY)
            // 保存item的y坐标
            yOffset[column] = yOffset[column] + height
            
            // 设置column的索引
            column = column < (numberOfColumns - 1) ? (column + 1) : 0  // 下一个总是依次排列（第一列第二列第一列第二列这样），两列的数量相等，如果第一列总是比第二列高，会出现两列高度相差很多的情况
            
            // 改成下面这种，下一个总是从高度小的那一列开始，可能会导致两列数量不想等，不会出现两列高度相差很多
//            let newColumn = column < (numberOfColumns - 1) ? (column + 1) : 0
//            if yOffset[column] > yOffset[newColumn] {
//                column = newColumn
//            }
        }
    }
    
    
    /// 返回给定矩形中所有视图的布局信息（可见范围内）
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    
    /// 根据需要返回指定索引的布局信息
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
