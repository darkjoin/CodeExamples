//
//  VideoWatermarkViewController.swift
//  WatermarkDemo
//
//  Created by darkgm on 2020/11/6.
//

import UIKit
import AVKit

class VideoWatermarkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        loadSubview()
        layoutSubview()
    }

    private func loadData() {
        prepareVideo()
    }
    
    private func loadSubview() {
        view.addSubview(playerView)
    }
    
    private func layoutSubview() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            playerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    lazy var inputURL: URL? = {
        let url = Bundle.main.url(forResource: "testVideo", withExtension: "MOV")
        return url
    }()
    
    lazy var outputURL: URL? = {
        let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("tempTest.mp4")
        return url
    }()
    
    lazy var player: AVPlayer = {
        let player = AVPlayer(playerItem: AVPlayerItem(url: inputURL!))
        return player
    }()
    
    lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        layer.videoGravity = .resizeAspect
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    
    lazy var playerView: PlayerView = {
        let view = PlayerView(frame: view.bounds)
        view.layer.insertSublayer(playerLayer, at: 0)
        view.isReadyToPlay = false
        view.playHandler = { [weak self] in
            self?.play()
        }
        view.pauseHandler = { [weak self] in
            self?.pause()
        }
        return view
    }()
}

extension VideoWatermarkViewController {
    private func prepareVideo() {
        guard let outputURL = self.outputURL, let inputURL = self.inputURL else { return }
        
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try? FileManager.default.removeItem(atPath: outputURL.path)
        }
        addWatermark(from: inputURL, to: outputURL) { [weak self] exportSession in
            guard let session = exportSession else { return }
            switch session.status {
            case .completed:
                guard NSData(contentsOf: outputURL) != nil else { return }
                DispatchQueue.main.async {
                    self?.player.replaceCurrentItem(with: AVPlayerItem(url: outputURL))
                    self?.playerView.isReadyToPlay = true
                }
            default:
                return
            }
        }
    }
    
    private func play() {
        player.play()
    }
    
    private func pause() {
        player.pause()
    }
}

extension VideoWatermarkViewController {
    private func addWatermark(from inputURL: URL, to outputURL: URL, completionHandler: @escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let mixComposition = AVMutableComposition()
        let asset = AVAsset(url: inputURL)
        let timeRange = CMTimeRangeMake(start: .zero, duration: asset.duration)
        guard let videoTrack = asset.tracks(withMediaType: .video).first,
              let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        else { return }
        
        do {
            try compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: .zero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            print(error.localizedDescription)
        }
        
        guard let watermarkFilter = CIFilter(name: "CISourceOverCompositing"),
              let image = getImage(from: "watermark"),
              let watermarkImage = CIImage(image: image)
        else { return }
        let videoComposition = AVVideoComposition(asset: asset) { filteringRequest in
            let source = filteringRequest.sourceImage.clampedToExtent()
            watermarkFilter.setValue(source, forKey: "inputBackgroundImage")
            let transform = CGAffineTransform(translationX: (filteringRequest.sourceImage.extent.width - watermarkImage.extent.width) / 2, y: 100)
            watermarkFilter.setValue(watermarkImage.transformed(by: transform), forKey: "inputImage")
            filteringRequest.finish(with: watermarkFilter.outputImage!, context: nil)
        }
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset640x480) else {
            completionHandler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously {
            completionHandler(exportSession)
        }
    }
    
    private func getImage(from text: String) -> UIImage? {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = text
        label.sizeToFit()
        UIGraphicsBeginImageContext(label.bounds.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        label.layer.render(in: currentContext)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class PlayerView: UIView {
    var isReadyToPlay = false {
        willSet {
            label.isHidden = newValue
            button.isHidden = !newValue
        }
    }
    var playHandler: (() -> Void)?
    var pauseHandler: (() -> Void)?
    var shouldPlay = false {
        willSet {
            newValue ? playHandler?() : pauseHandler?()
            button.setTitle(newValue ? "Pause" : "Play", for: .normal)
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
        addSubview(label)
        addSubview(button)
    }
    
    private func layoutSubview() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: self.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 100),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Play", for: .normal)
        view.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    @objc func buttonTapped(_ button: UIButton) {
        shouldPlay = !shouldPlay
    }
}
