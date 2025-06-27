//
//  MPMediaItem+Extensions.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//

import SwiftUI
import MediaPlayer

extension MPMediaItem {
    var image: Image? {
        if let artwork = self.artwork, let uiImage = artwork.image(at: artwork.bounds.size) {
            return Image(uiImage: uiImage)
                .resizable()
        }
        return nil
    }
}
