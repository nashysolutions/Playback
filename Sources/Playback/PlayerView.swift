import SwiftUI
import Combine
import AVFoundation

public final class VideoPlayerView: UIView {
    
    public var player: AVPlayer? {
        get {
            return (layer as? AVPlayerLayer)?.player
        }
        set {
            (layer as? AVPlayerLayer)?.player = newValue
        }
    }
    
    override public class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        if let playerLayer = layer as? AVPlayerLayer {
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
}

public struct PlayerView: UIViewRepresentable {
    
    let player: AVPlayer
    
    public init(player: AVPlayer) {
        self.player = player
    }
        
    public func makeUIView(context: Context) -> VideoPlayerView {
        let view = VideoPlayerView()
        view.player = player
        return view
    }
    
    public func updateUIView(_ playerView: VideoPlayerView, context: Context) {
        
    }
}

public extension PlayerView {
    
    final class Model: NSObject, ObservableObject {
        
        private var currentTime: CMTime?
        
        private var url: URL? {
            willSet {
                switch newValue {
                case .none:
                    player = nil
                case .some(let unwrapped):
                    if url != unwrapped {
                        player = AVPlayer(url: unwrapped)
                    }
                }
            }
        }
        
        @Published public var player: AVPlayer?
        
        private let shouldReplay: Bool
        
        private var playerItemDidReachEndCancellable: AnyCancellable?
        private var appDidBecomeActiveCancellable: AnyCancellable?
        private var appWillResignActiveCancellable: AnyCancellable?
        
        private var publisherFactory: NotificationCenter {
            NotificationCenter.default
        }
        
        public init(shouldReplay: Bool) {
            
            self.shouldReplay = shouldReplay
            
            super.init()
            
            playerItemDidReachEndCancellable = publisherFactory.publisher(
                for: NSNotification.Name.AVPlayerItemDidPlayToEndTime
            ).sink(receiveValue: { [weak self] _ in
                if self?.shouldReplay == true {
                    self?.play()
                }
            })
            
            appDidBecomeActiveCancellable = publisherFactory.publisher(
                for: UIApplication.didBecomeActiveNotification
            ).sink(receiveValue: { [weak self] _ in
                self?.resume()
            })
            
            appWillResignActiveCancellable = publisherFactory.publisher(
                for: UIApplication.willResignActiveNotification
            ).sink(receiveValue: { [weak self] _ in
                print("willResignActiveNotification")
                self?.pause()
            })
        }
        
        public func loadFrom(url: URL) {
            self.url = url
        }
        
        public func play() {
            play(at: .zero)
        }
        
        public func resume() {
            play(at: currentTime)
        }
        
        private func play(at time: CMTime?) {
            player?.play(atTime: time)
        }
        
        public func pause() {
            currentTime = player?.currentTime()
            player?.pause()
        }
    }
}
