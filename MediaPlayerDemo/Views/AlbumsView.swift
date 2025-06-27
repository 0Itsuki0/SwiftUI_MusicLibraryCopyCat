//
//  AlbumsView.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//

import SwiftUI
import MediaPlayer

struct AlbumsView: View {
    @Environment(MusicManager.self) private var musicManager

    var body: some View {
        let (albums, sections): ([MPMediaItemCollection],  [MPMediaQuerySection]) = musicManager.albums
        
        ScrollView {
            if albums.isEmpty {
                Text("No albums found.")
                    .foregroundStyle(.gray)
                    .padding(.all, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            LazyVGrid(columns: .init(repeating: .init(.flexible(minimum: UIScreen.main.bounds.width/3), spacing: 12), count: 2), spacing: 24, content: {

                ForEach(sections, id: \.self) { section in
                    Section {
                        let albumsInSection: [MPMediaItemCollection] = Array(albums[section.range.lowerBound..<section.range.upperBound])
                        
                        ForEach(albumsInSection, id: \.self) { album in
                            
                            NavigationLink(destination: {
                                MediaItemCollectionView(collection: album, isPlaylist: false)
                                    .environment(self.musicManager)

                            }, label: {
                                VStack(alignment: .leading) {
                                    if let image = album.image {
                                        image
                                            .scaledToFit()
                                            .aspectRatio(1, contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))

                                    } else {
                                        Image(systemName: "music.note")
                                            .font(.system(size: 48))
                                            .aspectRatio(1, contentMode: .fit)
                                            .foregroundStyle(.gray.opacity(0.6))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    
                                    Text(album.albumTitle)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .foregroundStyle(.black)

                                    Text(album.albumArtist)
                                        .lineLimit(1)
                                        .font(.caption)
                                        .foregroundStyle(.gray)

                                }
                            })
                            .navigationLinkIndicatorVisibility(.hidden)
                            
                        }

                    } header: {
                        Text(section.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                    }
                    .contentMargins(.top, 0)
                }
            })
            .padding(.horizontal, 16)
            .padding(.vertical, 24)

        }
        .navigationTitle("Albums")
        .navigationBarTitleDisplayMode(.large)
        .safeAreaInset(edge: .bottom, content: {
            PlayerView()
                .environment(self.musicManager)
        })
    }

}
