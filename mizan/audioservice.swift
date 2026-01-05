import Foundation
import AVFoundation

class audioservice: ObservableObject {
    static let shared = audioservice()
    
    @Published var playing = false
    @Published var currenturl: String?
    
    private var player: AVPlayer?
    
    private init() {
        setupaudiosession()
    }
    
    private func setupaudiosession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("audio session error: \(error)")
        }
    }
    
    func play(url: String) {
        guard let audiourl = URL(string: url) else {
            print("invalid audio url: \(url)")
            return
        }
        
        stop()
        
        player = AVPlayer(url: audiourl)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.stop()
        }
        
        player?.play()
        playing = true
        currenturl = url
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
