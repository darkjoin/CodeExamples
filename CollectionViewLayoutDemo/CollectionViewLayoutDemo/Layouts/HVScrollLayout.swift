//
//  HVScrollLayout.swift
//  CollectionViewLayoutDemo
//
//  Created by darkgm on 2021/7/21.
//
// 参考：https://www.brightec.co.uk/blog/uicollectionview-using-horizontal-and-vertical-scrolling-sticky-rows-and-columns?destination=taxonomy/term/1

import UIKit

class HVScrollLayout: UICollectionViewLayout {
    
    let numberOfColumns = 30 // 这里如何从数据源获取对应的列数？如果每个section的item个数不一致要如何处理？
    
    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var itemsSize = [CGSize]()
    var contentSize: CGSize = .zero
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else { return }
        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if section != 0 && item != 0 { continue }
                
                let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))!
                if section == 0 { // 用于垂直滚动时固定第一行
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }
                if item == 0 { // 用于水平滚动时固定第一列
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }
            attributes.append(contentsOf: filteredArray)
        }
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.item]
    }
}

extension HVScrollLayout {
    func generateItemAttributes(collectionView: UICollectionView) {
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        itemAttributes = []
        itemsSize = []
        
        if itemsSize.count != numberOfColumns {
            calculateItemSizes()
        }
        
        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
            for index in 0..<numberOfColumns {
                let itemSize = itemsSize[index]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                if section == 0 && index == 0 {
                    attributes.zIndex = 1024 // 第一个cell在最上面
                } else if section == 0 || index == 0 {
                    attributes.zIndex = 1023 // 第一行或者第一列应该在其他cell的上面
                }
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                column += 1
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            itemAttributes.append(sectionAttributes)
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }
    
    func calculateItemSizes() {
        itemsSize = []
        for index in 0..<numberOfColumns {
            itemsSize.append(sizeForItemWithColumnIndex(index)) // 动态计算itemSize
//            itemsSize.append(CGSize(width: 120, height: 80)) // 固定size
        }
    }
    
    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        let text = "Column \(columnIndex)"
        let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)])
        let width: CGFloat = size.width + 60
        return CGSize(width: width, height: 80)
    }
}
