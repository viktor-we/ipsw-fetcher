//
//  ModelsList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct DevicesList: View {

    @EnvironmentObject var data_object: DataObject
    
    @State private var show_favorites = false
    @State private var filter = FilterCategory.all
    @State private var selected_device: Device?

    @State private var text_field = ""
    
    var filtered_devices: [Device] {
        data_object.devices.filter { device in
            (filter == .all || device.name.contains(filter.rawValue)) &&
            (!show_favorites || device.is_favorite) &&
            (text_field == "" || device.name.lowercased().contains(text_field.lowercased()))
        }
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selected_device) {
                ForEach (filtered_devices, id:\.identifier) { device in
                    NavigationLink(destination: DeviceList(device: device)) {
                        DevicesRow(device: device)
                    }
                }
            }
            .frame(minWidth:400)
            .toolbar {
                SearchBar(text: $text_field)
                Picker("devices_filter_category", selection: $filter) {
                    ForEach(FilterCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                Toggle(isOn: $show_favorites) {
                    Label("devices_favorites_only", systemImage: show_favorites ? "star.fill" : "star")
                }
                Button(action: {
                    data_object.fetch_devices_from_api()
                    data_object.fetch_firmwares_from_api()
                    data_object.find_firmware_versions()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
        }
        }
    }
}
