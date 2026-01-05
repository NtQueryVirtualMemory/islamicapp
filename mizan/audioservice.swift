import Foundation
import AVFoundation
import Combine

class audioservice: ObservableObject {
    static let shared = audioservice()
    
    @Published var playing = false
    @Published var currenturl: String?
    @Published var currenttitle = ""
    @Published var currentsubtitle = ""
    @Published var currenttime: Double = 0
    @Published var duration: Double = 0
    @Published var progress: Double = 0
    @Published var speed: Float = 1.0
    @Published var repeatmode = false
    
    private var player: AVPlayer?
    private var timeobserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private var playlist: [audioitem] = []
    private var currentindex = 0
    
    private init() {
        setupaudiosession()
    }
    
    private func setupaudiosession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.allowBluetooth, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("audio session error: \(error)")
        }
    }
    
    func play(url: String, title: String = "", subtitle: String = "") {
        guard let audiourl = URL(string: url) else {
            print("invalid audio url: \(url)")
            return
        }
        
        stop()
        
        let item = AVPlayerItem(url: audiourl)
        player = AVPlayer(playerItem: item)
        player?.rate = speed
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.handleplaybackend()
        }
        
        timeobserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currenttime = time.seconds
            if let duration = self.player?.currentItem?.duration.seconds, !duration.isNaN {
                self.duration = duration
                self.progress = duration > 0 ? time.seconds / duration : 0
            }
        }
        
        player?.play()
        playing = true
        currenturl = url
        currenttitle = title
        currentsubtitle = subtitle
    }
    
    func playqueue(items: [audioitem], startindex: Int = 0) {
        playlist = items
        currentindex = startindex
        if let item = playlist[safe: currentindex] {
            play(url: item.url, title: item.title, subtitle: item.subtitle)
        }
    }
    
    func stop() {
        if let observer = timeobserver {
            player?.removeTimeObserver(observer)
            timeobserver = nil
        }
        player?.pause()
        player = nil
        playing = false
        currenturl = nil
        currenttime = 0
        duration = 0
        progress = 0
    }
    
    func toggleplay() {
        if playing {
            player?.pause()
            playing = false
        } else {
            player?.play()
            playing = true
        }
    }
    
    func toggle(url: String, title: String = "", subtitle: String = "") {
        if playing && currenturl == url {
            stop()
        } else {
            play(url: url, title: title, subtitle: subtitle)
        }
    }
    
    func seek(to progress: Double) {
        guard let duration = player?.currentItem?.duration.seconds, !duration.isNaN else { return }
        let time = CMTime(seconds: duration * progress, preferredTimescale: 600)
        player?.seek(to: time)
    }
    
    func cyclespeed() {
        switch speed {
        case 1.0:
            speed = 1.5
        case 1.5:
            speed = 2.0
        case 2.0:
            speed = 0.75
        default:
            speed = 1.0
        }
        player?.rate = speed
    }
    
    func togglerepeat() {
        repeatmode.toggle()
    }
    
    func next() {
        guard !playlist.isEmpty else { return }
        currentindex = (currentindex + 1) % playlist.count
        if let item = playlist[safe: currentindex] {
            play(url: item.url, title: item.title, subtitle: item.subtitle)
        }
    }
    
    func previous() {
        guard !playlist.isEmpty else { return }
        currentindex = currentindex > 0 ? currentindex - 1 : playlist.count - 1
        if let item = playlist[safe: currentindex] {
            play(url: item.url, title: item.title, subtitle: item.subtitle)
        }
    }
    
    private func handleplaybackend() {
        if repeatmode {
            player?.seek(to: .zero)
            player?.play()
        } else if !playlist.isEmpty {
            next()
        } else {
            stop()
        }
    }
}

struct audioitem {
    let url: String
    let title: String
    let subtitle: String
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
