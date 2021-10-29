//
//  Model.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import Foundation

struct Device: Hashable, Codable {
    var identifier, name: String
    
    var is_favorite: Bool = false
    
    var os_name: String {
        if self.name.contains("iPhone") {
            return "iOS"
        } else if self.name.contains("iPod") {
            return "iOS"
        } else if self.name.contains("iPad") {
            return "iPadOS"
        } else if self.name.contains("Mac") {
            return "macOS"
        } else if self.name.contains("Apple TV") {
            return "tvOS"
        } else if self.name.contains("HomePod") {
            return "audioOS"
        } else if self.name.contains("Apple Watch") {
            return "watchOS"
        }
        return "OS"
    }
}
