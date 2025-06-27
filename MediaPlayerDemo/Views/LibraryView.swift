//
//  LibraryView.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//

import SwiftUI
import AVFoundation

struct LibraryView: View {
    @Environment(MusicManager.self) private var musicManager
    
    @State var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        
        NavigationStack {
            List {
                NavigationLink(destination: {
                    AlbumsView()
                        .environment(self.musicManager)
                }, label: {
                    HStack(spacing: 24) {
                        Image(systemName: "square.stack")
                            .foregroundStyle(.pink)
                        Text("Albums")
                    }
                })
                .listRowBackground(Color.clear)

                NavigationLink(destination: {
                    PlaylistsView()
                        .environment(self.musicManager)
                }, label: {
                    HStack(spacing: 24) {
                        Image(systemName: "music.note.list")
                            .foregroundStyle(.pink)
                        Text("Playlists")
                    }
                })
                .listRowBackground(Color.clear)

            }
            .navigationTitle("Music Library")
            .safeAreaInset(edge: .bottom, content: {
                PlayerView()
                    .environment(self.musicManager)
            })
        }
    }
    
}
