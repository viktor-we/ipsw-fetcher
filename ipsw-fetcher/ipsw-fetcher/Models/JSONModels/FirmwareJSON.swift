//
//  FirmwareJSON.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 16.10.21.
//

import Foundation

struct FirmwareJSON: Hashable, Codable {
    var identifier, version, buildid,sha1sum,md5sum, sha256sum, url  : String
    var filesize: Int
    var signed: Bool
}
