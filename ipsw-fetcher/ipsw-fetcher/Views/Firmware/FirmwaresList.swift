//
//  FirmwaresList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct FirmwaresList: View {
    @EnvironmentObject var deviceData: DeviceData
    
    @State private var selected_firmware: FirmwareVersion?
    @State private var filter = FilterOSCategory.all
    @State private var sorting = SortingOSCategory.none
    
    var filtered_firmwares : [FirmwareVersion] {
        deviceData.firmware_versions.filter({ firmware in
            (filter == .all || firmware.os_name.contains(filter.rawValue))
        })
    }
    
    var sorted_firmwares : [FirmwareVersion] {
        filtered_firmwares.sorted(by: {
            if ( sorting == .version ) {
                return $0.buildid > $1.buildid
            } else {
                return false
            }
        })
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
                Menu {
                    Picker("Sort By", selection: $sorting) {
                        ForEach(SortingOSCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    Picker("Category", selection: $filter) {
                        ForEach(FilterOSCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                } label: {
                    Label("Filter", systemImage: "slider.horizontal.3")
                }
                Button(action: {
                    deviceData.find_firmware_versions()
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct FirmwaresList_Previews: PreviewProvider {
    static var previews: some View {
        FirmwaresList()
            .environmentObject(DeviceData())
    }
}
