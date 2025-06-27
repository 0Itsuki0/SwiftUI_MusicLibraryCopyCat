//
//  MediaItemCollections.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//


import SwiftUI
import MediaPlayer

extension MPMediaItemCollection {
    var image: Image? {
        return self.representativeItem?.image?.resizable()
    }
    
    var albumTitle: String {
        if let representativeItem = self.representativeItem {
            return representativeItem.albumTitle ?? "(Unknown album)"
        }

        return "(Unknown album)"
    }
    
    var albumArtist: String {
        if let representativeItem = self.representativeItem {
            return representativeItem.albumArtist ?? "(Unknown artist)"
        }
        
        return "(Unknown artist)"
    }
    
    var totalDuration: TimeInterval {
        return self.items.reduce(0) { result, item in
            result + item.playbackDuration
        }
    }
}
