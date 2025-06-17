//
//  Item.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
