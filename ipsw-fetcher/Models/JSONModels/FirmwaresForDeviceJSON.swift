//
//  FirmwaresForDeviceJSON.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 19.10.21.
//

import Foundation

struct FirmwaresForDeviceJSON: Hashable, Codable {
    var name: String
    var identifier: String
    var firmwares: [FirmwareJSON]
}
