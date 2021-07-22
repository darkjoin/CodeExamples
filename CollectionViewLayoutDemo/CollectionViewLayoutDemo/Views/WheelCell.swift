//
//  WheelCell.swift
//  CollectionViewLayoutDemo
//
//  Created by darkgm on 2021/7/21.
//

import UIKit

class WheelCell: CollectionViewCell {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let circularLayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularLayoutAttributes.anchorPoint
        self.center.y += (circularLayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
}
