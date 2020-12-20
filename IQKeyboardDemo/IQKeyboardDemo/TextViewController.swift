//
//  TextViewController.swift
//  IQKeyboardDemo
//
//  Created by darkgm on 2020/12/7.
//

import UIKit
import IQKeyboardManagerSwift

class TextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSubview()
        layoutSubview()
    }
    
    @objc private func stepperValueChange(_ sender: UIStepper) {
        UIView.animate(withDuration: 0.5) {
            self.textView.snp.updateConstraints { (make) in
                make.height.equalTo(60 + 10 * sender.value)
            }
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
        }
    }
    
    private func loadSubview() {
        view.addSubview(stepper)
        view.addSubview(textView)
    }
    
    private func layoutSubview() {
        stepper.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(stepper.snp.bottom).offset(30)
            make.height.equalTo(60)
        }
    }
    
    lazy var stepper: UIStepper = {
        let view = UIStepper()
        view.minimumValue = 0
        view.maximumValue = 20
        view.value = 0
        view.stepValue = 1
        view.isContinuous = true
        view.wraps = false
        view.addTarget(self, action: #selector(stepperValueChange(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        view.text = "IQKeyboardManager works on all orientations, and with the toolbar. It also has nice optional features allowing you to customize the distance from the text field, behaviour of previous, next and done buttons in the keyboard toolbar, play sound when the user navigates through the form and more.\nIQKeyboardManager works on all orientations, and with the toolbar. It also has nice optional features allowing you to customize the distance from the text field, behaviour of previous, next and done buttons in the keyboard toolbar, play sound when the user navigates through the form and more.\nIQKeyboardManager works on all orientations, and with the toolbar. It also has nice optional features allowing you to customize the distance from the text field, behaviour of previous, next and done buttons in the keyboard toolbar, play sound when the user navigates through the form and more."
        return view
    }()
}

extension TextViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        if count >= 15 || count >= 30 || count >= 45 || count >= 60 || count >= 75 {
            // 不清楚这句的作用是什么，没太明白怎么用
            IQKeyboardManager.shared.reloadLayoutIfNeeded()
        }
    }
}

