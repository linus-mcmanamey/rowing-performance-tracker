//
//  Item.swift
//  d_n_w
//
//  Created by Linus McManamey on 5/8/2025.
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
