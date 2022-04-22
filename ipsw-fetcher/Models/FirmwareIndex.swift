//
//  FirmwareIndex.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 22.04.22.
//

import Foundation

struct FirmwareIndex: Hashable, Codable {
    var identifier, version, buildid, sha1sum, md5sum, sha256sum  : String
    var url: URL
    var filesize: Int
    var signed: Bool
    
    var device_name, os_name, filename: String
    var is_downloaded: Bool
    
    var index: Int = 0
}
