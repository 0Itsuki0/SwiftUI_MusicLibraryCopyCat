//
//  PlaylistsView.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//

import SwiftUI
import MediaPlayer

struct PlaylistsView: View {
    @Environment(MusicManager.self) private var musicManager
    
    var body: some View {
        let playlists = musicManager.playlists

        List {
            if playlists.isEmpty {
                Text("No playlists found.")
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.vertical, 8)
                    .listRowInsets(.horizontal, 0)
            }
            
            ForEach(playlists, id: \.self) { playlist in
                NavigationLink(destination: {
                    MediaItemCollectionView(collection: playlist, isPlaylist: true)
                        .environment(self.musicManager)

                }, label: {
                    HStack {
                        if let image = playlist.image {
                            image
                                .scaledToFit()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundStyle(.gray.opacity(0.6))
                                .frame(width: 64, height: 64)
                                .background(.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Text(playlist.name ?? "(Unknown Playlist)")
                            .lineLimit(1)
                            .foregroundStyle(.black)
                    }
                })
                
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.vertical, 8)
            .listRowInsets(.horizontal, 0)

        }
        .navigationTitle("Playlists")
        .navigationBarTitleDisplayMode(.large)
        .safeAreaInset(edge: .bottom, content: {
            PlayerView()
                .environment(self.musicManager)
        })
    }
}
