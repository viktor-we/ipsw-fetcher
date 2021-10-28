//
//  ModelData.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import Foundation
import Combine
import SwiftUI

let fm = FileManager.default

let library_path = fm.urls(for: .libraryDirectory, in: .userDomainMask).first!

let ipsw_path = library_path.appendingPathComponent("ipsw-fetcher/")
let devices_path = ipsw_path.appendingPathComponent("devices.json")
let firmwares_path = ipsw_path.appendingPathComponent("firmwares.json")

let local_files_itunes_path = library_path.appendingPathComponent("iTunes/")
let local_files_iphone_path = local_files_itunes_path.appendingPathComponent("iPhone Software Updates/")
let local_files_ipad_path = local_files_itunes_path.appendingPathComponent("iPad Software Updates/")

let url_devices = URL(string: "https://api.ipsw.me/v4/devices")!
let url_firmware_for_device = URL(string: "https://api.ipsw.me/v4/device/")!

enum FilterCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case iphone = "iPhone"
    case ipad = "iPad"
    case ipod = "iPod"
    
    var id: FilterCategory {self}
}

enum FilterOSCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case ios = "iOS"
    case ipados = "iPadOS"
    
    var id: FilterOSCategory {self}
}

func decode <T: Decodable>(_ data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse")
    }
}

func version_number_greater_than(_ lhs: String, _ rhs: String) -> Bool {
    let lhs_splitted = lhs.split(separator: ".")
    let rhs_splitted = rhs.split(separator: ".")
    
    for i in 0..<lhs_splitted.count {
        if i < rhs_splitted.count {
            if (Int(lhs_splitted[i])! > Int(rhs_splitted[i])!) {
                return true
            } else if (Int(lhs_splitted[i])! < Int(rhs_splitted[i])!) {
                return false
            }
        } else {
            return true
        }
    }
    return false
}
