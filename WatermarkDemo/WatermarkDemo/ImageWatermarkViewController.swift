//
//  ImageWatermarkViewController.swift
//  WatermarkDemo
//
//  Created by darkgm on 2020/11/6.
//

import UIKit

class ImageWatermarkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSubview()
        layoutSubview()
        imageView.image = addWatermarkOnImage(with: "watermark")
    }
    
    private func loadSubview() {
        view.addSubview(imageView)
    }
    
    private func layoutSubview() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bg")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view 
    }()
    
    func addWatermarkOnImage(with text: String) -> UIImage? {
        guard let image = imageView.image else { return nil }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 80), NSAttributedString.Key.backgroundColor: UIColor(white: 0.9, alpha: 0.2)]
        let text = NSString(string: text)
        let textSize = text.size(withAttributes: attributes)
        text.draw(in: CGRect(x: image.size.width * 0.4, y: image.size.height * 0.8, width: textSize.width, height: textSize.height), withAttributes: attributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}



//extension UIImage {
//    func drawTextInImage()->UIImage {
//        //开启图片上下文
//        UIGraphicsBeginImageContext(self.size)
//        //图形重绘
//        self.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
//        //水印文字属性
//        let att = [NSForegroundColorAttributeName:UIColor.red,NSFontAttributeName:UIFont.systemFont(ofSize: 60),NSBackgroundColorAttributeName:UIColor.green]
//        //水印文字大小
//        let text = NSString(string: "**集团")
//        let size =  text.size(attributes: att)
//        //绘制文字
//        text.draw(in: CGRect.init(x: self.size.width-450, y: self.size.height-80, width: size.width, height: size.height), withAttributes: att)
//        //从当前上下文获取图片
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        //关闭上下文
//        UIGraphicsEndImageContext()
//
//        return image!
//
//    }
//}
