//
//  MediaItemCollectionView.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//

import SwiftUI
import MediaPlayer

struct MediaItemCollectionView: View {
    @Environment(MusicManager.self) var musicManager
    var collection: MPMediaItemCollection
    var isPlaylist: Bool = false
    
    var body: some View {
        let playlist = collection as? MPMediaPlaylist
        let title = isPlaylist ? playlist?.name ?? "Unknown Playlist" : collection.albumTitle
        let subtitle: String? = isPlaylist ? playlist?.descriptionText : collection.albumArtist
        let totalCount: Int = collection.count
        let totalDuration: TimeInterval = collection.totalDuration
        let items: [MPMediaItem] = collection.items

        List {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 120))
                        .foregroundStyle(.gray.opacity(0.6))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                    
                    VStack {
                        Text(title)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        if let subtitle {
                            Text(subtitle)
                                .font(.default)
                                .foregroundStyle(.gray)

                        }
                    }
                    
                    Divider()

                }
                .listRowBackground(Color.clear)
            }
            .listSectionSpacing(0)
            .listSectionMargins(.top, 0)


            Section {
                if items.isEmpty {
                    Text("No items in this \(isPlaylist ? "playlist" : "album").")
                        .font(.default)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.gray)
                        .listRowBackground(Color.clear)
                }
                
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        self.musicManager.selectedItem = item
                    }, label: {
                        HStack {
                            if let image = item.image {
                                image
                                    .scaledToFit()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                            } else {
                                Image(systemName: "music.note")
                                    .font(.system(size: 24))
                                    .aspectRatio(1, contentMode: .fit)
                                    .foregroundStyle(.gray.opacity(0.6))
                                    .frame(width: 40, height: 40)
                                    .background(.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            VStack(alignment: .leading) {
                                Text(item.title ?? "(Unknown item)")
                                    .lineLimit(1)

                                if let artist = item.artist {
                                    Text(artist)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    })
                    .buttonStyle(.plain)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.vertical, 8)
                .listRowInsets(.horizontal, 0)

            }
            .listSectionSpacing(0)
            .listSectionMargins(.top, -8)

            if !items.isEmpty {
                Section {
                    VStack(spacing: 16) {
                        Divider()

                        Group {
                            let songs = "\(totalCount) \(totalCount <= 1 ? "song" : "songs")"
                            if let formattedString = totalDuration.formattedString {
                                Text("\(songs), \(formattedString)")
                            } else {
                                Text("\(songs)")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    }
                    .listRowBackground(Color.clear)

                }
                .listSectionSpacing(0)
                .listSectionMargins(.top, -8)

            }
        }
        .safeAreaInset(edge: .bottom, content: {
            PlayerView()
                .environment(self.musicManager)
        })

    }
}
