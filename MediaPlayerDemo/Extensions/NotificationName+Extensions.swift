//
//  NotificationName+Extensions.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//

import SwiftUI

extension Notification.Name {
    var publisher: NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: self)
    }
}
