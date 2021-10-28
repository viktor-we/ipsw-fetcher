//
//  FirmwaresList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct FirmwaresList: View {
    @EnvironmentObject var device_data: DataObject
    
    @State private var selected_firmware: FirmwareVersion?
    @State private var filter = FilterOSCategory.all
    
    @State private var text_field = ""
    
    var filtered_firmwares : [FirmwareVersion] {
        device_data.firmware_versions.filter({ firmware in
            (filter == .all || firmware.os_name.contains(filter.rawValue)) &&
            (text_field == "" || firmware.os_name.lowercased().contains(text_field.lowercased()) || firmware.version.lowercased().contains(text_field.lowercased()))
        })
    }
    
    var sorted_firmwares : [FirmwareVersion] {
        filtered_firmwares.sorted {
            return version_number_greater_than($0.version, $1.version)
        }
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selected_firmware) {
                ForEach(sorted_firmwares, id:\.id) { firmware_version in
                    NavigationLink(destination: FirmwareDetail(firmware_version: firmware_version)) {
                        FirmwareRow(firmware_version: firmware_version)
                    }
                }
            }
            .frame(minWidth:400)
            .toolbar {
                SearchBar(text: $text_field)
                Picker("Category", selection: $filter) {
                    ForEach(FilterOSCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                Button(action: {
                    device_data.find_firmware_versions()
                }) {
                    Text("Update Firmwares")
                }
            }
        }
    }
}

struct FirmwaresList_Previews: PreviewProvider {
    static var previews: some View {
        FirmwaresList()
            .environmentObject(DataObject())
    }
}
