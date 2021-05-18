import UIKit
import AVFoundation

open class VideoPlayerViewController: UIViewController {
    
    var currentTime: CMTime?
    
    private let playerView = VideoPlayerView()
    
    private var playerItemDidReachEndObserver: NSObjectProtocol?
    private var appDidBecomeActiveObserver: NSObjectProtocol?
    private var appWillResignActiveObserver: NSObjectProtocol?
    
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
        
        let center = NotificationCenter.default
        playerItemDidReachEndObserver = center.addObserver(
            forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: nil,
            using: { _ in
                if self.shouldReplay() {
                    self.playerView.player?.play(atTime: .zero)
                }
            })
        
        appDidBecomeActiveObserver = center.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: nil,
            using: { _ in
                self.play()
            })
        
        appWillResignActiveObserver = center.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: nil,
            using: { _ in
                self.pause(logCurrentTime: true)
            })
    }
    
    open func playerItem() -> AVPlayerItem? {
        return nil
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.player?.play(atTime: currentTime)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pause(logCurrentTime: true)
    }
    
    public func play() {
        playerView.player?.play(atTime: currentTime)
    }
    
    public func pause(logCurrentTime logTime: Bool) {
        if let player = playerView.player {
            player.pause()
            if logTime {
                currentTime = player.currentTime()
            }
        }
    }
    
    open func shouldReplay() -> Bool {
        return false
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
