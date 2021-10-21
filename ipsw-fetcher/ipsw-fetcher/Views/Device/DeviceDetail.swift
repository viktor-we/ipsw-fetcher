//
//  DeviceDetail.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 16.10.21.
//

import SwiftUI

struct DeviceDetail: View {
    
    @EnvironmentObject var device_data: DeviceData
    
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
                    Text("Current \(device.os_name) version:")
                    Text(device_data.get_latest_firmware_for_device(identifier: device.identifier))
                        .font(.title2)
                }
            }
            .padding()
            Text("Firmwares:")
                .font(.title)
                .padding(.leading)
            List(device_data.get_firmwares_for_device(identifier: device.identifier), id: \.buildid) { firmware in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(device.os_name) \(firmware.version)")
                            .font(.title)
                            .padding(.bottom,0.5)
                            .foregroundColor(firmware.signed ? Color.green : Color.red)
                        Text(firmware.buildid)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        let filesize = Float(firmware.filesize) / 1024 / 1024 / 1024
                        Text(String(format:"%.2f GB", filesize))
                        Text(firmware.filename)
                    }
                    Image(systemName: firmware.is_downloaded ? "arrow.down.to.line.compact" : "arrow.down")
                    Button(action: {
                        device_data.download_firmware(firmware: firmware)
                    }) {
                        Text("Add to Downloads")
                    }
                }
                .padding(.bottom,5)
            }
        }
    }
}

struct DeviceDetail_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetail(device: DeviceData().devices.last!)
    }
}
