//
//  FirmwaresPerVersion.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 02.05.22.
//

import Foundation

struct FirmwaresPerVersion {
    var id = UUID()
    var version: String
    var buildid: String
    var os_name: String
    var signed: Bool
    
    var firmwares = [Int]()
}
