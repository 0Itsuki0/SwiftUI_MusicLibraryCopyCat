//
//  MusicManager.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/26.
//

import SwiftUI
import MediaPlayer
import Combine


@Observable
@MainActor
class MusicManager: NSObject {
    
    var status: MPMediaLibraryAuthorizationStatus
    
    var albums: ([MPMediaItemCollection], [MPMediaQuerySection]) = ([], [])
    var playlists: [MPMediaPlaylist] = []
    
    var selectedItem: MPMediaItem? {
        didSet {
            guard oldValue?.assetURL != self.selectedItem?.assetURL else { return }
            guard let item = self.selectedItem, let url = item.assetURL else {
                self.player?.stop()
                self.player = nil
                return
            }
            do {
                self.player?.stop()
                self.player = try AVAudioPlayer(contentsOf: url)
            } catch(let error) {
                print("error creating player: \(error)")
                self.player = nil
            }
            
        }
    }

    var player: AVAudioPlayer? {
        didSet {
            if self.player != oldValue {
                self.isPlaying = false
            }
        }
    }
    
    // player.isPlaying is not a published variable
    var isPlaying: Bool = false {
        didSet {
            if self.isPlaying {
                self.player?.play()
            } else {
                self.player?.pause()
            }
        }
    }

    private let query = MPMediaQuery.songs()
    
    private var cancellable: AnyCancellable?

    override init() {
        self.status = MPMediaLibrary.authorizationStatus()

        super.init()
        self.configureAudioSession()
        
        Task {
            self.initializeAlbums()
        }
        Task {
            self.initializePlaylist()
        }
        
        // listen for updates
        MPMediaLibrary.default().beginGeneratingLibraryChangeNotifications()
        self.cancellable = Notification.Name.MPMediaLibraryDidChange.publisher.receive(
            on: DispatchQueue.main
        ).sink { notification in
            Task {
                self.initializeAlbums()
            }
            Task {
                self.initializePlaylist()
            }
        }
    }
    
    deinit {
        MPMediaLibrary.default().endGeneratingLibraryChangeNotifications()
    }

    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            // Configure the app for playback of long-form movies.
            try session.setCategory(.playback, mode: .default, options: [.duckOthers])
            try session.setActive(true)
        } catch(let error) {
            print(error)
        }
    }


    // take time
    func getByAlbums() -> ([MPMediaItemCollection], [MPMediaQuerySection]) {
        query.groupingType = .album
        let collections = query.collections ?? []
        let sections: [MPMediaQuerySection] = query.collectionSections ?? []
        
        return (collections, sections)
    }
    
    
    func initializeAlbums() {
        query.groupingType = .album
        let collections = query.collections ?? []
        let sections: [MPMediaQuerySection] = query.collectionSections ?? []
        self.albums = (collections, sections)
    }
    
    func initializePlaylist() {
        query.groupingType = .playlist
        let collections = query.collections ?? []
        let playlist = collections.map { $0 as? MPMediaPlaylist }.filter({$0 != nil}).map({$0!})
        self.playlists = playlist
    }
    
    func requestAuthorization() async {
        self.status = await MPMediaLibrary.requestAuthorization()
    }
    
}

extension MusicManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == self.player {
            self.isPlaying = false
        }
    }
}
