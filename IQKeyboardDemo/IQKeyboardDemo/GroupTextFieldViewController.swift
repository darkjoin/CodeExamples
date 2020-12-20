//
//  GroupTextFieldViewController.swift
//  IQKeyboardDemo
//
//  Created by darkgm on 2020/11/23.
//

import UIKit
import IQKeyboardManagerSwift

class GroupTextFieldViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         如果textField不在同一个父类，需要设置其父类在IQPreviousNextView中，否则不会自动上下导航到期望的文本框
         可以将self.view设置为IQPreviousNextView，也可以将textField所在的父类添加到textField中
         注释掉下面这句可以看到问题
         */
        view = previousNextView
        
        loadSubview()
        layoutSubview()
    }
    
    private func loadSubview() {
        view.addSubview(firstView)
        view.addSubview(secondView)
        view.addSubview(thirdView)
    }
    
    private func layoutSubview() {
        firstView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        secondView.snp.makeConstraints { (make) in
            make.left.right.equalTo(firstView)
            make.top.equalTo(firstView.snp.bottom).offset(20)
        }

        thirdView.snp.makeConstraints { (make) in
            make.left.right.equalTo(secondView)
            make.top.equalTo(secondView.snp.bottom).offset(20)
            make.bottom.lessThanOrEqualTo(-10)
        }
    }
    
    lazy var previousNextView: IQPreviousNextView = {
        let view = IQPreviousNextView()
        return view
    }()
    
    lazy var firstView: GroupTextFieldView = {
        let view = GroupTextFieldView()
        view.title = "A"
        view.placeholder = "请输入A"
        return view
    }()
    
    lazy var secondView: GroupTextFieldView = {
        let view = GroupTextFieldView()
        view.title = "B"
        view.placeholder = "请输入B"
        return view
    }()
    
    lazy var thirdView: GroupTextFieldView = {
        let view = GroupTextFieldView()
        view.title = "C"
        view.placeholder = "请输入C"
        return view
    }()

}

class GroupTextFieldView: UIView {
    
    var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    var placeholder: String? {
        willSet {
            textField.placeholder = newValue
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        loadSubview()
        layoutSubview()
    }
    
    private func loadSubview() {
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    private func layoutSubview() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
            make.right.bottom.equalTo(-10)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    lazy var textField: UITextField = {
        let control = UITextField()
        control.borderStyle = .roundedRect
        control.clearButtonMode = .whileEditing
        return control
    }()
}


