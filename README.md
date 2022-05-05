# Playback
A simple wrapper around AVFoundation to play a movie file.

# Usage - SwiftUI

```swift
import SwiftUI
import Playback

struct HomeView: View {

    @StateObject private var playerModel = PlayerView.Model(shouldReplay: true)

    @EnvironmentObject private var tabController: TabController

    var body: some View {
        // ...
        if let player = playerModel.player {
            PlayerView(player: player)
        }
        // ...
    }
    .onAppear {
        playerModel.loadFrom(url: url)
    }.onChange(of: tabController.activeTab) { activeTab in
        switch activeTab {
        case .home:
            playerModel.resume()
        default:
            playerModel.pause()
        }
    }
}
```

# Usage - UIKit

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
