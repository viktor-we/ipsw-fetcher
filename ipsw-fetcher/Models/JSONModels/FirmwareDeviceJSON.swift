//
//  FirmwareDeviceJSON.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 17.10.21.
//

import Foundation

struct FirmwareDeviceJSON: Hashable, Codable {
    var name: String
    var identifier: String
    var firmwares: [FirmwareJSON]
}
