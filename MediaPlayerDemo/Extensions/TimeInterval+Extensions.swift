//
//  TimeInterval+Extensions.swift
//  MediaPlayerDemo
//
//  Created by Itsuki on 2025/06/27.
//

import SwiftUI

extension TimeInterval{
    
    var formattedString: String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: self)
    }

}
