//
//  WebPatternWatermarkViewController.swift
//  WatermarkDemo
//
//  Created by darkgm on 2020/11/6.
//

import UIKit
import WebKit

class WebPatternWatermarkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        loadSubview()
        layoutSubview()
        
        addWatermarkView()
    }
    
    private func addWatermarkView() {
        // 使用Pattern
        addPatternWatermakView()
        
//        // 使用图片平铺
//        addImageTileWatermarkView()
    }
    
    private func addPatternWatermakView() {
        let patternWatermarkView = PatternWatermakView(frame: view.frame)
        patternWatermarkView.backgroundColor = .clear
        // 禁用交互，避免网页中的内容无法点击
        patternWatermarkView.isUserInteractionEnabled = false
        self.view.addSubview(patternWatermarkView)
    }
    
    private func addImageTileWatermarkView() {
        let patternWatermarkView = ImageTileWatermarkView(frame: view.frame)
        patternWatermarkView.backgroundColor = .clear
        patternWatermarkView.isUserInteractionEnabled = false
        self.view.addSubview(patternWatermarkView)
    }
    
    private func loadData() {
        guard let url = URL(string: "https://en.wikipedia.org/wiki/Main_Page") else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func loadSubview() {
        view.addSubview(webView)
    }
    
    private func layoutSubview() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    lazy var webView: WKWebView = {
        let view = WKWebView()
        view.scrollView.isScrollEnabled = true
        view.allowsBackForwardNavigationGestures = true
        return view
    }()

}
