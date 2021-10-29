//
//  FirmwareDeviceJSON.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 17.10.21.
//

import Foundation

struct FirmwareDeviceJSON: Hashable, Codable {
    var name, identifier: String
    var firmwares: [FirmwareJSON]
}
