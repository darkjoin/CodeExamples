//
//  SegmentViewController.swift
//  VibrateDemo
//
//  Created by darkgm on 2020/12/9.
//

import UIKit
import SnapKit

class SegmentViewController: UIViewController {
    
    private var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "VibrateDemo"
        setupControllers()
        loadSubview()
        layoutSubview()
        
        setSelectedIndex(index: 0)
        scrollView.contentSize = CGSize(width: Int(view.bounds.size.width) * viewControllers.count, height: 0)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        scrollView.setContentOffset(CGPoint(x: Int(view.bounds.size.width) * sender.selectedSegmentIndex, y: 0), animated: true)
        setSelectedIndex(index: sender.selectedSegmentIndex, animated: true)
    }
    
    private func setSelectedIndex(index: Int, animated: Bool = false) {
        let controller = viewControllers[index]
        if controller.parent == nil {
            addChild(controller)
            var rect = self.scrollView.bounds
            rect.origin.x = CGFloat(Int(view.bounds.size.width) * index)
            controller.view.frame = rect
            scrollView.addSubview(controller.view)
            controller.didMove(toParent: self)
        }
        
        if segmentedControl.selectedSegmentIndex != index {
            segmentedControl.selectedSegmentIndex = index
        }
        
        UIView.animate(withDuration: 0.2) { [unowned self] in
            let minX = segmentedControl.selectedSegmentIndex * (Int(view.bounds.size.width) / 2)
            indicateView.snp.updateConstraints { (make) in
                make.left.equalTo(minX)
            }
        }
    }
    
    private func setupControllers() {
        let hapticsController = HapticsViewController()
        viewControllers.append(hapticsController)
        
        let systemSoundController = SystemSoundViewController()
        viewControllers.append(systemSoundController)
    }
    
    
    private func loadSubview() {
        view.addSubview(segmentedControl)
        view.addSubview(indicateView)
        view.addSubview(scrollView)
    }
    
    private func layoutSubview() {
        segmentedControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(45)
        }
        
        indicateView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(view.bounds.size.width / 2)
            make.height.equalTo(2)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(3)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Haptics", "SystemSound"])
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)
        segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    lazy var indicateView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.delegate = self
        return view
    }()

}

extension SegmentViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / view.bounds.size.width)
        setSelectedIndex(index: index)
    }
}
