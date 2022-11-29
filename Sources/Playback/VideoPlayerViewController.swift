import UIKit
import AVFoundation

open class VideoPlayerViewController: UIViewController, VideoPlayerGatewayHandler {
    
    private let playerView = VideoPlayerView()
    
    private let gateway = VideoPlayerGateway()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let playerItem = playerItem() {
            playerView.player = AVPlayer(playerItem: playerItem)
        }
    }
    
    public func sendPlayerViewToBack() {
        view.sendSubviewToBack(playerView)
    }
    
    open func playerItem() -> AVPlayerItem? {
        return nil
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.player?.play(atTime: gateway.currentTime)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pause(logCurrentTime: true)
    }
    
    public func play() {
        playerView.player?.play(atTime: gateway.currentTime)
    }
    
    @available(iOS, renamed: "pause")
    public func pause(logCurrentTime logTime: Bool) {
        pause()
    }
    
    open func shouldReplay() -> Bool {
        return false
    }
    
    public func pause() {
        if let player = playerView.player {
            player.pause()
            gateway.currentTime = player.currentTime()
        }
    }
}

extension AVPlayer {
    
    func play(atTime time: CMTime?) {
        if let t = time, CMTIME_IS_VALID(t)  {
            seek(to: t)
        } else {
            seek(to: .zero)
        }
        
        play()
    }
}
