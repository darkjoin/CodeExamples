//
//  CustomLoginItemsView.swift
//  ThirdPartLoginDemo
//
//  Created by darkgm on 2021/4/21.
//

import UIKit

class CustomLoginItemsView: UIView {
    
    public enum LoginItemType {
        case Facebook   // Facebook登录
        case Line       // Line登录
        case Apple  // AppleID登录
    }
    
    public var loginItemClicked:((_ loginItemType: LoginItemType) -> Void)?
    private let loginItems = [
        ["type": LoginItemType.Facebook, "title": "Facebook", "icon": "icon_facebook"],
        ["type": LoginItemType.Line, "title": "Line", "icon": "icon_line"],
        ["type": LoginItemType.Apple, "title": "Apple", "icon": "icon_apple"]
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
        layoutSubview()
        addLoginItems()
    }
    
    private func setupSubview() {
        addSubview(containerView)
    }
    
    private func layoutSubview() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func addLoginItems() {
        for item in loginItems {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitle(item["title"] as? String, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: (item["icon"] as? String)!), for: .normal)
            button.imagePosition(style: .top, spacing: 6)
            button.setClickClosure { [weak self] (button) in
                self?.loginItemClicked?(item["type"] as! LoginItemType)
            }
            containerView.addArrangedSubview(button)
        }
    }
    
    lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
}



var controlClickClosureKey = "controlClickClosureKey"
extension UIControl {
    
    typealias ControlClickClosure = (UIControl) -> Void
    
    func setClickClosure(clickClosure: @escaping ControlClickClosure) {
        self.clickClosure = clickClosure
        self.addTarget(self, action: #selector(onClick(button:)), for: .touchUpInside)
    }
    
    @objc private func onClick(button: UIButton) {
        self.clickClosure?(button)
    }
    
    private var clickClosure: ControlClickClosure? {
        get {
            return objc_getAssociatedObject(self, &controlClickClosureKey) as? UIControl.ControlClickClosure
        }
        set {
            objc_setAssociatedObject(self, &controlClickClosureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIButton {
    enum FEButtonImagePosition {
        case top          //图片在上，文字在下，垂直居中对齐
        case bottom       //图片在下，文字在上，垂直居中对齐
        case left         //图片在左，文字在右，水平居中对齐
        case right        //图片在右，文字在左，水平居中对齐
    }
    /// - Description 设置Button图片的位置
    /// - Parameters:
    ///   - style: 图片位置
    ///   - spacing: 按钮图片与文字之间的间隔
    func imagePosition(style: FEButtonImagePosition, spacing: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.image?.size.width
        let imageHeight = self.imageView?.image?.size.height
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-spacing/2, right: 0)
            break;
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            break;
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-spacing/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-spacing/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-spacing/2, bottom: 0, right: imageWidth!+spacing/2)
            break;
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}
