//
//  WebTextWatermarkViewController.swift
//  WatermarkDemo
//
//  Created by darkgm on 2020/11/6.
//

import UIKit
import WebKit

class WebTextWatermarkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        loadSubview()
        layoutSubview()
        
        // 在View上添加水印
//        addWaterMarkLayer(in: view, with: "watermark")
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
        view.navigationDelegate = self
        return view
    }()

}

extension WebTextWatermarkViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 在webView上添加水印
        self.addWaterMarkLayer(in: self.webView, with: "watermark")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if error._code == NSURLErrorCancelled {
            return
        }
        showError(error.localizedDescription)
    }
}

extension WebTextWatermarkViewController {
    
    private func addWaterMarkLayer(in view: UIView, with text: String, textFont: UIFont? = UIFont.systemFont(ofSize: 12)) {
        guard !text.isEmpty else { return }
        
        var textSize = calculateTextSize(text: text, maxSize: CGSize(width: UIScreen.main.bounds.width, height: 200), fontSize: 12)
        textSize = CGSize(width: textSize.width + 10, height: textSize.height + 10)
        
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = 12
        textLayer.contentsScale = UIScreen.main.scale
        let color = UIColor.init(white: 0.6, alpha: 1)
        textLayer.foregroundColor = color.cgColor
        textLayer.alignmentMode = .center
        textLayer.frame.size = textSize
        textLayer.transform = CATransform3DMakeRotation(.pi / 6, 0, 0, -1)

        let horizontalReplicatorLayer = CAReplicatorLayer()
        let horizontalSpace: CGFloat = 100.0
        horizontalReplicatorLayer.frame.size = self.view.frame.size
//        horizontalReplicatorLayer.masksToBounds = true
//        let instanceCount = view.frame.size.width / textSize.width + 1
        let instanceCount = ceil(view.frame.size.width / horizontalSpace)
        horizontalReplicatorLayer.instanceCount = Int(instanceCount)
        horizontalReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(horizontalSpace, 0, 0)
        horizontalReplicatorLayer.addSublayer(textLayer)

        let verticalReplicatorLayer = CAReplicatorLayer()
        let verticalSpace: CGFloat = 100.0
        verticalReplicatorLayer.frame.size = self.view.frame.size
        verticalReplicatorLayer.masksToBounds = true
//        let verticalInstanceCount = view.frame.size.height / size.height
        let verticalInstanceCount = view.frame.size.height / verticalSpace
        verticalReplicatorLayer.instanceCount = Int(verticalInstanceCount)
        verticalReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, verticalSpace, 0)
        verticalReplicatorLayer.addSublayer(horizontalReplicatorLayer)

        self.view.layer.addSublayer(verticalReplicatorLayer)
    }
    
    func calculateTextSize(text: String, maxSize: CGSize, fontSize: CGFloat) -> CGSize {
        
        var size = CGSize.init(width: 0, height: 0)
        let textNS = (text as NSString)
        size = textNS.boundingRect(with: CGSize(width: maxSize.width, height: maxSize.height), options:[NSStringDrawingOptions.truncatesLastVisibleLine,NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading] , attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)], context: nil).size
        
        return size
    }
    
    private func showError(_ errorString: String?) {
        let alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}
