//
//  Firmware.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import Foundation

struct Firmware: Identifiable, Hashable, Codable {
    var identifier, version, buildid, sha256sum: String
    var url: URL
    var filesize: Int
    var signed: Bool
    
    var device_name, os_name, filename: String
    var is_downloaded: Bool
    
    var id = UUID()
}
