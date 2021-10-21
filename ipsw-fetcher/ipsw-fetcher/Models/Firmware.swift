//
//  Firmware.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import Foundation

struct Firmware: Hashable, Codable {
    var identifier, version, buildid, sha1sum, md5sum, sha256sum  : String
    var url: URL
    var filesize: Int
    var signed: Bool
    
    var device_name: String
    
    var os_name: String
    
    var filename: String
    
    var is_downloaded: Bool
}
