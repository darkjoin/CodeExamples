//
//  ImageTileWatermarkView.swift
//  WatermarkDemo
//
//  Created by darkgm on 2020/11/6.
//

import UIKit

/// 图片平铺水印
class ImageTileWatermarkView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        loadSubview()
        
        var image = UIImage(named: "circle")
        image = image?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        imageView.image = image
    }
    
    private func loadSubview() {
        addSubview(imageView)
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: self.bounds)
        view.transform = CGAffineTransform(rotationAngle: -45)
        view.contentMode = .scaleAspectFill
        return view
    }()
}
