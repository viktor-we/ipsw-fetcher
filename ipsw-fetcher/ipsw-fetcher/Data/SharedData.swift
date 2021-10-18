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

let resourcePath = Bundle.main.resourcePath!
let libraryPath = fm.urls(for: .libraryDirectory, in: .userDomainMask).first!

let ipswPath = libraryPath.appendingPathComponent("ipsw-fetcher/")
let devicesPath = ipswPath.appendingPathComponent("devices.json")
let firmwaresPath = ipswPath.appendingPathComponent("firmwares.json")

let local_files_iphone_path = libraryPath.appendingPathComponent("iTunes/iPhone Software Updates/")
let local_files_ipad_path = libraryPath.appendingPathComponent("iTunes/iPad Software Updates/")

let url_devices = URL(string: "https://api.ipsw.me/v4/devices")!
let url_firmwares = URL(string: "https://api.ipsw.me/v4/ipsw/15.0.2")!
let url_firmware_for_device = URL(string: "https://api.ipsw.me/v4/device/")!

func decode <T: Decodable>(_ data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse")
    }
}
