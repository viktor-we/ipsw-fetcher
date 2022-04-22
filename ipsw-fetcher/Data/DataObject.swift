//
//  DeviceData.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 15.10.21.
//

import Foundation
import Combine
import UserNotifications

final class DataObject: ObservableObject {
    
    @Published var devices = [Device]() {
        didSet {
            self.save_devices_model()
        }
    }
    
    @Published var firmware_versions = [FirmwareVersion]()
    
    @Published var firmwares = [Firmware]()
    
    @Published var local_files_iphone = [LocalFile]()
    
    @Published var local_files_ipad = [LocalFile]()
    
    @Published var download_tasks = [DownloadTask]()
    
    init() {
        if !fm.fileExists(atPath: ipsw_path.path) {
            do {
                try fm.createDirectory(at: ipsw_path, withIntermediateDirectories: true)
            } catch {
                print("Directory could not be created")
            }
        }
        
        if (fm.fileExists(atPath: devices_path.path)) {
            self.load_devices_model()
        } else {
            self.fetch_devices_from_api()
        }
        
        if (fm.fileExists(atPath: firmwares_path.path)) {
            self.load_firmwares_model()
        } else {
            self.fetch_firmwares_from_api()
        }

        self.find_firmware_versions()
        self.fetch_local_files()
        self.find_downloaded_firmwares()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    // DEVICES
    
    func fetch_devices_from_api() {
        var new_devices = [Device]()
        var request = URLRequest(url: url_devices)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let sem = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                sem.signal()
            }
            if response != nil {
                if let data = data {
                    let devices_json: [DeviceJSON] = decode(data)
                    for device_json in devices_json {
                        var existing = false
                        for device in self.devices {
                            if device_json.identifier == device.identifier {
                                existing = true
                            }
                        }
                        if !existing {
                            if !(device_json.name.contains("iBridge") || device_json.name.contains("Developer Transition Kit") ||
                                 device_json.name.contains("Watch") || device_json.name.contains("Mac") ||
                                 device_json.name.contains("TV") || device_json.name.contains("HomePod")) {
                                new_devices.append(Device(identifier: device_json.identifier, name: device_json.name))
                            }
                        }
                    }
                }
            } else {
                print(error ?? "Unknown error")
            }
        }
        task.resume()
        sem.wait()
        self.devices.append(contentsOf: new_devices)
    }
    
    // FIRMWARES
    
    func fetch_firmwares_from_api() {
        var new_firmwares = [Firmware]()
        for device in self.devices {
            let url_firmware = url_firmware_for_device.appendingPathComponent(device.identifier)
            var request = URLRequest(url: url_firmware)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let sem = DispatchSemaphore.init(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                defer {
                    sem.signal()
                }
                if response != nil {
                    if let data = data {
                        let decoded_model: FirmwaresForDeviceJSON = decode(data)
                        for decoded_firmware in decoded_model.firmwares {
                            let firmware = Firmware(identifier: decoded_firmware.identifier, version: decoded_firmware.version, buildid: decoded_firmware.buildid,
                                                    sha1sum: decoded_firmware.sha1sum, md5sum: decoded_firmware.md5sum, sha256sum: decoded_firmware.sha256sum,
                                                    url: decoded_firmware.url, filesize: decoded_firmware.filesize, signed: decoded_firmware.signed,
                                                    device_name: device.name, os_name: device.os_name, filename: String(decoded_firmware.url.path.split(separator:"/").last!), is_downloaded: false)
                            new_firmwares.append(firmware)
                        }
                    }
                } else {
                    print(error ?? "Unknown error")
                }
            }
            task.resume()
            sem.wait()
        }
        firmwares = new_firmwares
        self.save_firmwares_model()
    }
    
    func get_firmwares_for_device(identifier: String) -> [FirmwareIndex] {
        var return_value = [FirmwareIndex]()
        for firmware in firmwares {
            if firmware.identifier == identifier {
                return_value.append(FirmwareIndex(identifier: firmware.identifier, version: firmware.version, buildid: firmware.buildid, sha1sum: firmware.sha1sum, md5sum: firmware.md5sum, sha256sum: firmware.sha256sum, url: firmware.url, filesize: firmware.filesize, signed: firmware.signed, device_name: firmware.device_name, os_name: firmware.os_name, filename: firmware.filename, is_downloaded: firmware.is_downloaded, index: return_value.count))
            }
        }
        return return_value
    }
    
    func get_firmwares_for_version(version: String, os_name:String) -> [FirmwareIndex] {
        var return_value = [FirmwareIndex]()
        for firmware in self.firmwares {
            if (firmware.version == version && firmware.os_name == os_name) {
                return_value.append(FirmwareIndex(identifier: firmware.identifier, version: firmware.version, buildid: firmware.buildid, sha1sum: firmware.sha1sum, md5sum: firmware.md5sum, sha256sum: firmware.sha256sum, url: firmware.url, filesize: firmware.filesize, signed: firmware.signed, device_name: firmware.device_name, os_name: firmware.os_name, filename: firmware.filename, is_downloaded: firmware.is_downloaded, index: return_value.count))
            }
        }
        return return_value
    }
    
    func get_latest_firmware_for_device(identifier: String) -> String {
        for firmware in firmwares {
            if firmware.identifier == identifier {
                return "\(firmware.version)"
            }
        }
        return "None"
    }
    
    // FIRMWARE VERSIONS LIST
    
    func find_firmware_versions() {
        for firmware in self.firmwares {
            if !self.find_existing_firmware_version(os_name: firmware.os_name, version: firmware.version) {
                self.firmware_versions.append(FirmwareVersion(version: firmware.version, buildid: firmware.buildid, os_name: firmware.os_name, signed: firmware.signed))
                
            }
        }
    }
    
    func find_existing_firmware_version(os_name: String, version: String) -> Bool {
        for firmware_version in firmware_versions {
            if firmware_version.version == version {
                if firmware_version.os_name == os_name {
                    return true
                }
            }
        }
        return false
    }
    
    // Load/Save
    
    func load_devices_model() {
        let data: Data
        do {
            data = try Data(contentsOf: devices_path)
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
            try data.write(to: devices_path)
        } catch {
            print("Error while encoding to JSON")
        }
    }
    
    func load_firmwares_model() {
        let data: Data
        do {
            data = try Data(contentsOf: firmwares_path)
        } catch {
            fatalError("Couldn't find file.")
        }
        self.firmwares = decode(data)
    }
    
    func save_firmwares_model() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self.firmwares)
            try data.write(to: firmwares_path)
        } catch {
            print("Error while encoding to JSON")
        }
    }
    
    // Local files
    
    func fetch_local_files() {
        DispatchQueue.main.async {
            self.local_files_iphone = [LocalFile]()
            do {
                let local_files = try (fm.contentsOfDirectory(at: local_files_iphone_path,includingPropertiesForKeys: nil, options: []))
                for i in 0..<local_files.count {
                    let fileName = local_files[i].absoluteString
                    self.local_files_iphone.append(LocalFile(file_name: String(fileName.split(separator:"/").last!),index: i))
                }
            } catch {
                print("Local Files not found")
            }
            
            self.local_files_ipad = [LocalFile]()
            do {
                let localFilesStrings = try (fm.contentsOfDirectory(at: local_files_ipad_path,includingPropertiesForKeys: nil, options: []))
                for i in 0..<localFilesStrings.count {
                    let fileName = localFilesStrings[i].absoluteString
                    self.local_files_ipad.append(LocalFile(file_name: String(fileName.split(separator:"/").last!),index: i))
                }
            } catch {
                print("Local Files not found")
            }
            self.find_downloaded_firmwares()
        }
    }
    
    func find_downloaded_firmwares() {
        DispatchQueue.global(qos: .userInitiated).async {
            for i in 0..<self.firmwares.count {
                var is_downloaded = false
                if self.firmwares[i].os_name == "iOS" {
                    for local_file_iphone in self.local_files_iphone {
                        if (self.firmwares[i].filename == local_file_iphone.file_name) {
                            is_downloaded = true
                        }
                    }
                } else if self.firmwares[i].os_name == "iPadOS" {
                    for local_file_ipad in self.local_files_ipad {
                        if (self.firmwares[i].filename == local_file_ipad.file_name) {
                            is_downloaded = true
                        }
                    }
                }
                if (self.firmwares[i].is_downloaded != is_downloaded){
                    DispatchQueue.main.async {
                        self.firmwares[i].is_downloaded = is_downloaded
                        
                    }
                }
            }
        }
    }
    
    func delete_local_file_iphone(_ filename: String) {
        let path = local_files_iphone_path.appendingPathComponent(filename)
        for i in 0..<firmwares.count {
            if firmwares[i].filename == filename {
                firmwares[i].is_downloaded = false
            }
        }
        do {
            try fm.removeItem(at: path)
        } catch {
            print("file could not be deleted")
        }
        fetch_local_files()
    }
    
    func delete_local_file_ipad(_ filename:String) {
        let path = local_files_ipad_path.appendingPathComponent(filename)
        for i in 0..<firmwares.count {
            if firmwares[i].filename == filename {
                firmwares[i].is_downloaded = false
            }
        }
        do {
            try fm.removeItem(at: path)
        } catch {
            print("file could not be deleted")
        }
        fetch_local_files()
    }
    
    // Downloads
    
    func create_download_task(firmware: FirmwareIndex) {
        var download_existing = false
        for download_task in download_tasks {
            if download_task.firmware.filename == firmware.filename {
                download_existing = true
            }
        }
        for local_file_ipad in local_files_ipad {
            if local_file_ipad.file_name == firmware.filename {
                download_existing = true
            }
        }
        for local_file_iphone in local_files_iphone {
            if local_file_iphone.file_name == firmware.filename {
                download_existing = true
            }
        }
        if !download_existing {
            self.download_tasks.append(DownloadTask(firmware: firmware, data_object: self, index:download_tasks.count))
        }
    }
    
    func delete_download_task(download_task: DownloadTask) {
        var index = -1
        for i in 0..<download_tasks.count {
            if download_task.id == download_tasks[i].id {
                index = i
            }
        }
        if index != -1 {
            download_tasks.remove(at: index)
        }
    }
    
    
    func start_next_download() {
        var started = false
        for download_task in download_tasks {
            if !download_task.completed && !started {
                download_task.bulk_download = true
                download_task.start_download()
                started = true
            }
        }
    }
    
    func cancel_every_download() {
        for download_task in download_tasks {
            download_task.cancel_download()
        }
    }
    
    func pause_every_download() {
        for download_task in download_tasks {
            download_task.pause_download()
        }
    }
    
    func delete_completed_downloads() {
        for download_task in download_tasks {
            if download_task.completed {
                self.delete_download_task(download_task: download_task)
            }
        }
    }
    
    func delete_every_download() {
        cancel_every_download()
        self.download_tasks.removeAll()
    }

    func alert_finished_download(filename: String) {
        var completed = 0
        for download_task in download_tasks {
            if download_task.completed {
                completed += 1
            }
        }
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notification_title",comment: "")
        content.subtitle = filename
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: completed)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}
