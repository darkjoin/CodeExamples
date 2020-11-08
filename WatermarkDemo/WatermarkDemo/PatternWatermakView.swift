//
//  PatternWatermakView.swift
//  WatermarkDemo
//
//  Created by darkgm on 2020/11/6.
//

import UIKit

/// CGPattern绘制水印
class PatternWatermakView: UIView {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
//        var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawDotPattern, releaseInfo: nil)   // 小圆点图案
        var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawTextPattern, releaseInfo: nil)    // 文字
        guard let pattern = CGPattern(info: nil, bounds: CGRect(x: 0, y: 0, width: 20, height: 20), matrix: .identity, xStep: 50, yStep: 50, tiling: .constantSpacing, isColored: true, callbacks: &callbacks), let patternSpace = CGColorSpace(patternBaseSpace: nil) else { return }
        context?.setFillColorSpace(patternSpace)
        var alpha: CGFloat = 1.0
        context?.setFillPattern(pattern, colorComponents: &alpha)
        context?.fill(rect)
    }
    
    /// 绘制小圆点
    let drawDotPattern: CGPatternDrawPatternCallback = {_, context in
        context.addArc(center: CGPoint(x: 20, y: 20), radius: 10.0, startAngle: 0, endAngle: CGFloat(.pi * 2.0), clockwise: false)
        let color = UIColor.init(white: 0.8, alpha: 1)
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
    
    /// 绘制文字
    let drawTextPattern: CGPatternDrawPatternCallback = {_, context in
        context.saveGState()
        context.translateBy(x: 50, y: 50)
        context.rotate(by: CGFloat(-6.0 * 5 * .pi / 180))
        context.move(to: CGPoint(x: 72, y: 0))
        context.scaleBy(x: 1, y: -1)
        let text = "watermark"
        let textColor = UIColor.init(white: 0.6, alpha: 1)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : textColor.cgColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]
        let attributedString = NSAttributedString(string: text as String, attributes: attributes)
        let textSize = text.size(withAttributes: attributes)
        let font = attributes[NSAttributedString.Key.font] as! UIFont
        let textPath = CGPath(rect: CGRect(x: -42, y: 0 + font.descender, width: ceil(textSize.width), height: ceil(textSize.height)), transform: nil)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: attributedString.length), textPath, nil)
        CTFrameDraw(frame, context)
        context.restoreGState()
    }

}
