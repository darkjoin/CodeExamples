//
//  MainViewController.swift
//  PHPickerViewControllerDemo
//
//  Created by darkgm on 2020/10/15.
//

import UIKit
import PhotosUI
import AVFoundation

class MainViewController: UIViewController {
    
    var itemProviders: [NSItemProvider] = []
    var iterator: IndexingIterator<[NSItemProvider]>?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "PHPickerViewControllerDemo"
        loadSubview()
        layoutSubview()
    }
    
    private func loadSubview() {
        view.addSubview(PHPickerButton)
        view.addSubview(imagePickerButton)
        view.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(playerView)
    }
    
    /// 展示PHPickerViewController
    /// - Parameter button: button
    @objc private func showPHPickerViewController(_ button: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0    // 0表示无上限 // 默认是1
//        configuration.filter = .any(of: [.images, .videos, .livePhotos])
        configuration.filter = .any(of: [.images, .videos])
        configuration.preferredAssetRepresentationMode = .automatic
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    /// 展示UIImagePickerController
    /// - Parameter button: button
    @objc private func showUIImagePickerController(_ button: UIButton) {
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.movie", "public.image"] // 选择的媒体类型
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayNextItem()
    }
    
    // MARK: Properties
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    lazy var PHPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ShowPHPickerViewController", for: .normal)
        button.addTarget(self, action: #selector(showPHPickerViewController(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var imagePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ShowUIImagePickerController", for: .normal)
        button.addTarget(self, action: #selector(showUIImagePickerController(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var playerView: UIView = {
        let view = UIView()
        return view
    }()
}

// MARK: 逻辑处理
extension MainViewController {
    /// 展示选择的下一个内容
    private func displayNextItem() {
        if let itemProvider = iterator?.next() {
            if itemProvider.canLoadObject(ofClass: UIImage.self) { // image
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    DispatchQueue.main.async {
                        guard let self = self, let image = image as? UIImage else { return }
                        self.contentView.bringSubviewToFront(self.imageView)
                        self.imageView.image = image
                    }
                }
            } else { // video
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (url, error) in
                    guard let self = self, let url = url else { return }
                    let fileName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                    let newURL = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
                    try? FileManager.default.copyItem(at: url, to: newURL)
                    DispatchQueue.main.async {
                        self.contentView.bringSubviewToFront(self.playerView)
                        self.playVideo(newURL)
                    }
                }
            }
        }
    }
    
    /// 播放视频
    /// - Parameter url: URL地址
    private func playVideo(_ url: URL) {
        debugPrint(url)
        
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = playerView.frame
        playerView.layer.addSublayer(playerLayer)
        player.play()
    }
}

// MARK: Layout
extension MainViewController {
    
    private func layoutSubview() {
        PHPickerButton.translatesAutoresizingMaskIntoConstraints = false
        PHPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        PHPickerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imagePickerButton.topAnchor.constraint(equalTo: PHPickerButton.bottomAnchor, constant: 30).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: imagePickerButton.bottomAnchor, constant: 30).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

// MARK: PHPickerViewControllerDelegate
extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
    
        itemProviders = results.map(\.itemProvider)
        iterator = itemProviders.makeIterator()
        displayNextItem()
    }
}

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage { // image
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.contentView.bringSubviewToFront(self.imageView)
                self.imageView.image = image
            }
        } else if let url = info[.mediaURL] as? URL { // video
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.contentView.bringSubviewToFront(self.playerView)
                self.playVideo(url)
            }
        } else {
            return
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
