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
        }
        return "OS"
    }
}
