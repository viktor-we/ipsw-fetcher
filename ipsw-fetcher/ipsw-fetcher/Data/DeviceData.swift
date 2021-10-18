//
//  DeviceData.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 15.10.21.
//

import Foundation
import Combine
import SwiftUI

enum FilterCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case iphone = "iPhone"
    case ipad = "iPad"
    case ipod = "iPod"
    case mac = "Mac"
    case appletv = "Apple TV"
    case applewatch = "Apple Watch"
    case homepod = "HomePod"
    
    var id: FilterCategory {self}
}

enum FilterOSCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case ios = "iOS"
    case ipados = "iPadOS"
    case macos = "macOS"
    case tvos = "tvOS"
    case watchos = "watchOS"
    case audioos = "audioOS"
    
    var id: FilterOSCategory {self}
}

enum SortingCategory: String, CaseIterable, Identifiable {
    case none = "None"
    case identifier = "By Identifier"
    case name = "By Name"
    
    var id: SortingCategory {self}
}

enum SortingOSCategory: String, CaseIterable, Identifiable {
    case none = "None"
    case version = "By Version"
    
    var id: SortingOSCategory {self}
}

final class DeviceData: ObservableObject {
    
    @Published var devices = [Device]() {
        didSet {
            self.save_devices_model()
        }
    }
    
    @Published var firmware_versions = [FirmwareVersion]() {
        didSet {
            self.save_firmwares_model()
        }
    }
    
    @Published var local_files_iphone = [LocalFile]()
    @Published var local_files_ipad = [LocalFile]()
    
    init() {
        if !fm.fileExists(atPath: devicesPath.path) {
            fetch_devices()
        } else {
            load_devices_model()
        }
        if !fm.fileExists(atPath: firmwaresPath.path) {
            find_firmware_versions()
        } else {
            load_firmwares_model()
        }
        fetch_local_files()
    }
    
    func fetch_devices() {
        var request = URLRequest(url: url_devices)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if response != nil {
                if let data = data {
                    DispatchQueue.main.async {
                        self.update_devices(data: data)
                    }
                }
            } else {
                print(error ?? "Unknown error")
            }
        }
        task.resume()
    }
    
    func update_devices(data: Data) {
        let devicesFromJson: [DeviceJSON] = decode(data)
        self.devices.append(contentsOf: self.find_new_devices(devices: self.devices, devicesJSON: devicesFromJson))
        
        fetch_firmwares_for_devices()
    }
    
    func find_new_devices(devices: [Device], devicesJSON: [DeviceJSON]) -> [Device] {
        var new_devices = [Device]()
        for deviceJSON in devicesJSON {
            var existing = false
            for device in devices {
                if deviceJSON.identifier == device.identifier {
                    existing = true
                }
            }
            if !existing {
                if !(deviceJSON.name.contains("iBridge") || deviceJSON.name.contains("Developer Transition Kit")) {
                    new_devices.append(Device(identifier: deviceJSON.identifier, name: deviceJSON.name))
                }
            }
        }
        return new_devices
    }
    
    func fetch_firmwares_for_devices() {
        for device in devices {
            let url_firmware = url_firmware_for_device.appendingPathComponent(device.identifier)
            var request = URLRequest(url: url_firmware)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if response != nil {
                    if let data = data {
                        DispatchQueue.main.async {
                            self.update_firmwares_for_device(data: data, device_identifier: device.identifier)
                        }
                    }
                } else {
                    print(error ?? "Unknown error")
                }
            }
            task.resume()
        }
    }
    
    func update_firmwares_for_device(data: Data, device_identifier: String) {
        let device_json: FirmwareDeviceJSON = decode(data)
        let index_of_device_identifier = self.find_index(device_identifier: device_identifier)
        let name_of_device_identifier = self.get_device_name(identifier: device_identifier)
        var os_name = "OS"
        if name_of_device_identifier.contains("iPhone") {
            os_name = "iOS"
        } else if name_of_device_identifier.contains("iPod") {
            os_name = "iOS"
        } else if name_of_device_identifier.contains("iPad") {
            os_name = "iPadOS"
        } else if name_of_device_identifier.contains("Mac") {
            os_name = "macOS"
        } else if name_of_device_identifier.contains("Apple TV") {
            os_name = "tvOS"
        } else if name_of_device_identifier.contains("HomePod") {
            os_name = "audioOS"
        } else if name_of_device_identifier.contains("Apple Watch") {
            os_name = "watchOS"
        }
        
        var existing_firmware = false
        for firmware_json in device_json.firmwares {
            for firmware in self.devices[index_of_device_identifier].firmwares {
                if firmware_json.buildid != firmware.buildid {
                    existing_firmware = true
                }
            }
        }
        
        if !existing_firmware {
            var new_firmwares = [Firmware]()
            for firmware_json in device_json.firmwares {
                new_firmwares.append(Firmware(identifier: firmware_json.identifier, version: firmware_json.version, buildid: firmware_json.buildid,
                                              sha1sum: firmware_json.sha1sum, md5sum: firmware_json.md5sum, sha256sum: firmware_json.sha256sum,
                                              url: firmware_json.url, filesize: firmware_json.filesize, signed: firmware_json.signed,
                                              device_name: name_of_device_identifier, os_name: os_name))
            }
            self.devices[index_of_device_identifier].firmwares = new_firmwares
            
        }
    }
    
    func find_index(device_identifier: String) -> Int {
        for i in 0..<self.devices.count {
            if self.devices[i].identifier == device_identifier {
                return i
            }
        }
        return Int.max
    }
    
    func find_firmware_versions() {
        for device in devices {
            for firmware in device.firmwares {
                if (firmware.signed) {
                    let index = find_existing_firmware_version(os_name: firmware.os_name, version: firmware.version)
                    if index == -1 {
                        var new_firmware_version = FirmwareVersion(id: firmware_versions.count, version: firmware.version, buildid: firmware.buildid, os_name: firmware.os_name)
                        new_firmware_version.firmwares.append(firmware)
                        firmware_versions.append(new_firmware_version)
                    } else {
                        if !find_exisiting_firmware_in_firmware_verion(firmware_version_index: index, firmware_to_find: firmware) {
                            firmware_versions[index].firmwares.append(firmware)
                        }
                    }
                }
            }
        }
    }
    
    func find_existing_firmware_version(os_name: String, version: String) -> Int {
        for i in 0..<firmware_versions.count {
            if (firmware_versions[i].version == version) {
                if (firmware_versions[i].os_name == os_name) {
                    return i
                }
            }
        }
        return -1
    }
    
    func find_exisiting_firmware_in_firmware_verion(firmware_version_index: Int, firmware_to_find: Firmware) -> Bool {
        var exisiting = false
        for firmware in firmware_versions[firmware_version_index].firmwares {
            if firmware.identifier == firmware_to_find.identifier {
                exisiting = true
            }
        }
        return exisiting
    }
    
    func get_device_name(identifier: String) -> String {
        for i in 0..<devices.count {
            if devices[i].identifier == identifier {
                return devices[i].name
            }
        }
        return "No Name found"
    }
    
    func load_devices_model() {
        let data: Data
        do {
            data = try Data(contentsOf: devicesPath)
        } catch {
            fatalError("Couldn't find file.")
        }
        self.devices = decode(data)
        
    }
    
    func save_devices_model() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(devices)
            try data.write(to: devicesPath)
        } catch {
            print("Error while encoding to JSON")
        }
    }
    
    func load_firmwares_model() {
        let data: Data
        do {
            data = try Data(contentsOf: firmwaresPath)
        } catch {
            fatalError("Couldn't find file.")
        }
        self.firmware_versions = decode(data)
        
    }
    
    func save_firmwares_model() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(firmware_versions)
            try data.write(to: firmwaresPath)
        } catch {
            print("Error while encoding to JSON")
        }
    }
    
    func fetch_local_files() {
        local_files_iphone = [LocalFile]()
        do {
            let localFilesStrings = try (fm.contentsOfDirectory(at: local_files_iphone_path,includingPropertiesForKeys: nil, options: []))
            for i in 0..<localFilesStrings.count {
                let fileName = localFilesStrings[i].absoluteString
                local_files_iphone.append(LocalFile(id: i, name: String(fileName.split(separator:"/").last!)))
            }
        } catch {
            print("Local Files not found")
        }
        
        local_files_ipad = [LocalFile]()
        do {
            let localFilesStrings = try (fm.contentsOfDirectory(at: local_files_ipad_path,includingPropertiesForKeys: nil, options: []))
            for i in 0..<localFilesStrings.count {
                let fileName = localFilesStrings[i].absoluteString
                local_files_ipad.append(LocalFile(id: i, name: String(fileName.split(separator:"/").last!)))
            }
        } catch {
            print("Local Files not found")
        }
    }
    
    func delete_local_file(_ filename: String) {
        let path = local_files_iphone_path.appendingPathComponent(filename)
        print(path)
        do {
            try fm.removeItem(at: path)
        } catch {
            print("file could not be deleted")
        }
        fetch_local_files()
    }
    
}
