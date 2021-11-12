# Playback
A simple wrapper around AVFoundation to play a movie file.

# Usage

```swift
import Foundation
import AVFoundation
import Playback

final class HomeViewController: VideoPlayerViewController {
    
    override func shouldReplay() -> Bool {
        return true
    }
    
    override func playerItem() -> AVPlayerItem? {
        guard let url = Bundle.main.url(forResource: "Welcome", withExtension: "mov") else {
            return nil
        }
        return AVPlayerItem(url: url)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // optional
        sendPlayerViewToBack()
    }
}
```
