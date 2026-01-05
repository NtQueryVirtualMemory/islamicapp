import Foundation
import AVFoundation

class audioservice: ObservableObject {
    static let shared = audioservice()
    
    @Published var playing = false
    @Published var currenturl: String?
    
    private var player: AVPlayer?
    
    func play(url: String) {
        guard let audiourl = URL(string: url) else { return }
        
        stop()
        
        player = AVPlayer(url: audiourl)
        player?.play()
        playing = true
        currenturl = url
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.stop()
        }
    }
    
    func stop() {
        player?.pause()
        player = nil
        playing = false
        currenturl = nil
    }
    
    func toggle(url: String) {
        if playing && currenturl == url {
            stop()
        } else {
            play(url: url)
        }
    }
}
