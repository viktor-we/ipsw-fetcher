//
//  FirmwaresList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct FirmwaresList: View {
    
    @EnvironmentObject var device_data: DataObject
    
    @State private var show_only_signed = true
    @State private var selected_firmware: FirmwareVersion?
    @State private var filter = FilterOSCategory.all
    
    @State private var text_field = ""
    
    var filtered_firmwares : [FirmwareVersion] {
        device_data.firmware_versions.filter({ firmware in
            (filter == .all || firmware.os_name.contains(filter.rawValue)) &&
            (!show_only_signed || firmware.signed) &&
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
                    NavigationLink(destination: FirmwareList(firmware_version: firmware_version)) {
                        FirmwaresRow(firmware_version: firmware_version)
                    }
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
            .frame(minWidth:400)
            .toolbar {
                SearchBar(text: $text_field)
                Picker("firmwares_filter_category", selection: $filter) {
                    ForEach(FilterOSCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                Toggle(isOn: $show_only_signed) {
                    Text("firmwares_signed_only")
                }
                Button(action: {
                    device_data.fetch_from_api()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}
