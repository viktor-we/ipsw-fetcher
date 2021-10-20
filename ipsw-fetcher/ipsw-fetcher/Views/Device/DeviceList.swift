//
//  ModelsList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct DevicesList: View {

    @EnvironmentObject var deviceData: DeviceData
    
    @State private var showFavorites = false
    @State private var filter = FilterCategory.all
    @State private var selectedDevice: Device?
    @State private var sorting = SortingCategory.none

    
    var filteredDevices: [Device] {
        deviceData.devices.filter { device in
            (filter == .all || device.name.contains(filter.rawValue)) &&
            (!showFavorites || device.isFavorite) &&
            !(device.name.contains("iBridge") || device.name.contains("Developer Transition Kit"))
        }
    }
    
    var sortedDevices : [Device] {
        filteredDevices.sorted(by: {
            if ( sorting == .identifier ) {
                return $0.identifier > $1.identifier
            } else if ( sorting == .name) {
                return $0.name > $1.name
            } else {
                return false
            }
        })
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selectedDevice) {
                ForEach (sortedDevices, id:\.identifier) { device in
                    NavigationLink(destination: DeviceDetail(device: device)) {
                        DeviceRow(device: device)
                    }
                }
            }
            .frame(minWidth:600)
            .toolbar {
                Menu {
                    Picker("Sort By", selection: $sorting) {
                        ForEach(SortingCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    Picker("Category", selection: $filter) {
                        ForEach(FilterCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    Toggle(isOn: $showFavorites) {
                        Label("Favorites only", systemImage: "star.fill")
                    }
                } label: {
                    Label("Filter", systemImage: "slider.horizontal.3")
                }
                Button(action: {
                    deviceData.fetch_devices_from_api()
                    deviceData.fetch_firmwares_from_api()
                    deviceData.find_firmware_versions()
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(PlainButtonStyle())
        }
        }
    }
}

struct MDevicesList_Previews: PreviewProvider {
    static var previews: some View {
        DevicesList()
            .environmentObject(DeviceData())
    }
}
