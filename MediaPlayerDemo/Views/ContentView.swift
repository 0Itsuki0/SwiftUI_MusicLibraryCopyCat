//
//  ContentView.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/26.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    @State private var musicManager = MusicManager()

    var body: some View {
        let status = musicManager.status

        Group {
            switch status {
            case .authorized:
                LibraryView()
                    .environment(self.musicManager)
            
            case .denied:
                ContentUnavailableView(label: {
                    Label("Access Denied", systemImage: "xmark.square")
                }, description: {
                    Text("The app doesn't have permission to access media library. Please grant the app access in Settings.")
                        .multilineTextAlignment(.center)
                })
            case .notDetermined:
                ContentUnavailableView(label: {
                    Label("Unknown Access", systemImage: "questionmark.app")
                }, description: {
                    Text("The app requires access to the media library.")
                        .multilineTextAlignment(.center)
                }, actions: {
                    Button(action: {
                        Task {
                            await musicManager.requestAuthorization()
                        }
                    }, label: {
                        Text("request access")
                    })

                })
            case .restricted:
                ContentUnavailableView(label: {
                    Label("Restricted Access", systemImage: "lock.square")
                }, description: {
                    Text("This device doesn't allow access to media library. Please update the permission in Settings.")
                        .multilineTextAlignment(.center)
                })
                
            @unknown default:
                ContentUnavailableView(label: {
                    Label("Unknown", systemImage: "ellipsis.rectangle")
                }, description: {
                    Text("Unknown authorization status.")
                        .multilineTextAlignment(.center)
                })

            }
        }
        
    }
}
