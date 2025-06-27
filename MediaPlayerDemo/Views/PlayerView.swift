//
//  PlayerView.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//

import SwiftUI
import MediaPlayer

struct PlayerView: View {
    @Environment(MusicManager.self) private var musicManager
    
    var body: some View {
        if musicManager.player != nil, let selectedItem = musicManager.selectedItem {
            HStack(spacing: 24) {
                if let image = selectedItem.image {
                    image
                        .scaledToFit()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .layoutPriority(1)

                } else {
                    Image(systemName: "music.note")
                        .font(.system(size: 24))
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundStyle(.gray.opacity(0.6))
                        .frame(width: 40, height: 40)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .layoutPriority(1)
                }

                
                Text(selectedItem.title ?? "(Unknown)")
                    .font(.headline)
                    .layoutPriority(1)
                
                Spacer()
                
                Button(action: {
                    musicManager.isPlaying.toggle()
                    
                }, label: {
                    Image(systemName: musicManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .frame(width: 40, height: 40)
                })
                .buttonStyle(.plain)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Capsule()
                    .fill(.white.opacity(0.8))
            )
            .padding(.horizontal, 16)

        }
    }
}
