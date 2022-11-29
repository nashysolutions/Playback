import UIKit
import AVFoundation

typealias VideoPlayerGatewayHandler = VideoPlayerGatewayDataSource & VideoPlayerGatewayDelegate

final class VideoPlayerGateway {
    
    var currentTime: CMTime?
    
    weak var dataSource: VideoPlayerGatewayDataSource?
    weak var delegate: VideoPlayerGatewayDelegate?
    
    private var playerItemDidReachEndObserver: NSObjectProtocol?
    private var appDidBecomeActiveObserver: NSObjectProtocol?
    private var appWillResignActiveObserver: NSObjectProtocol?
    
    init(center: NotificationCenter = .default) {
        playerItemDidReachEndObserver = center.addObserver(
            forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: nil,
            using: didPlayToEndTime(notification:))
        
        appDidBecomeActiveObserver = center.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: nil,
            using: didBecomeActive(notification:))
        
        appWillResignActiveObserver = center.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: nil,
            using: willResignActive(notification:))
    }
    
    private func didPlayToEndTime(notification: Notification) {
        if let dataSource, dataSource.shouldReplay() {
            delegate?.play()
        }
    }
    
    private func didBecomeActive(notification: Notification) {
        delegate?.play()
    }
    
    private func willResignActive(notification: Notification) {
        delegate?.pause()
    }
}

protocol VideoPlayerGatewayDataSource: AnyObject {
    func shouldReplay() -> Bool
}

protocol VideoPlayerGatewayDelegate: AnyObject {
    func play()
    func pause()
}
