//
//  FirmwareData.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 15.10.21.
//

import Foundation
import Combine
import SwiftUI

final class FirmwareData1: ObservableObject {
    
    @Published var firmwares = [Firmware](){
        didSet {
            self.save_model()
        }
    }
    
    init() {
        if !fm.fileExists(atPath: firmwaresPath.path) {
            fetch_firmwares()
        } else {
            load_model()
        }
    }
    
    func update_firmwares(data: Data) {
        let firmwaresFromJson: [FirmwareJSON] = decode(data)
        self.firmwares.append(contentsOf: find_new_firmwares(firmwares: self.firmwares, firmwaresJSON: firmwaresFromJson))
    }
    
    func find_new_firmwares(firmwares: [Firmware], firmwaresJSON: [FirmwareJSON]) -> [Firmware] {
        var new_firmwares = [Firmware]()
        for firmwareJSON in firmwaresJSON {
            var existing = false
            for firmware in firmwares {
                if firmwareJSON.identifier == firmware.identifier {
                    existing = true
                }
            }
            if !existing {
                new_firmwares.append(
                    Firmware(identifier: firmwareJSON.identifier, version: firmwareJSON.version, buildid: firmwareJSON.buildid,
                             sha1sum: firmwareJSON.sha1sum, md5sum: firmwareJSON.md5sum, sha256sum: firmwareJSON.sha256sum,
                             url: firmwareJSON.url, filesize: firmwareJSON.filesize, signed: firmwareJSON.signed))
            }
        }
        return new_firmwares
    }
    
    func fetch_firmwares() {
        var request = URLRequest(url: url_firmwares)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if response != nil {
                if let data = data {
                    DispatchQueue.main.async {
                        self.update_firmwares(data: data)
                    }
                }
            } else {
                print(error ?? "Unknown error")
            }
        }
        task.resume()
    }
    
    func load_model() {
        let data: Data
        do {
            data = try Data(contentsOf: firmwaresPath)
        } catch {
            fatalError("Couldn't find file.")
        }
        self.firmwares = decode(data)
        
    }
    
    func save_model() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(firmwares)
            try data.write(to: firmwaresPath)
        } catch {
            print("Error while encoding to JSON")
        }
        
        
    }
}
