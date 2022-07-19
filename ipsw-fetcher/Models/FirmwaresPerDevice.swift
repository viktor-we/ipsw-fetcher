//
//  FirmwaresPerDevice.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 02.05.22.
//

import Foundation

struct FirmwaresPerDevice {
    var identifier: String
    var name: String
    
    var firmwares = [Int]()
}
