//
//  DeviceDetail.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 16.10.21.
//

import SwiftUI

struct DeviceList: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var device: Device
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(device.identifier)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    Text(device.name)
                        .font(.title)
                    Text(device.identifier)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("devices_current_version")
                    Text("\(device.os_name) \(data_object.get_latest_firmware_for_device(identifier: device.identifier))")
                        .font(.title2)
                }
                .padding()
            }
            .padding(.vertical,30)
            .padding()
            Text("devices_firmwares")
                .font(.title)
                .padding(.leading)
            List {
                ForEach(data_object.get_firmwares_for_device(identifier: device.identifier), id: \.buildid) { firmware in
                    DeviceRow(firmware:firmware)
                        .listRowBackground((firmware.index  % 2 == 0) ? Color(.clear) : color_grey)
                        //.padding(5)
                        .padding(.leading,10)
                        .padding(.trailing,10)
                }
            }
        }
        .frame(minWidth:600)
    }
}
