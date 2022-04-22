//
//  FirmwareVersion.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 17.10.21.
//

import Foundation

struct FirmwareVersion: Hashable, Codable {
    
    var id = UUID()
    var version: String
    var buildid: String
    var os_name: String
    var signed: Bool
    
    var icon_name: String {
        if (os_name == "iOS") {
            return "iphone"
        } else if (os_name == "iPadOS") {
            return "ipad"
        }
        return "exclamationmark.circle"
    }
}
