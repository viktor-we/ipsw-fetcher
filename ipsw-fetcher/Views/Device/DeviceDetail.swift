//
//  DeviceDetail.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 16.10.21.
//

import SwiftUI

struct DeviceDetail: View {
    
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
                    Text("Current \(device.os_name) version:")
                    Text(data_object.get_latest_firmware_for_device(identifier: device.identifier))
                        .font(.title2)
                }
            }
            .padding()
            Text("Firmwares:")
                .font(.title)
                .padding(.leading)
            List(data_object.get_firmwares_for_device(identifier: device.identifier), id: \.buildid) { firmware in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(device.os_name) \(firmware.version)")
                            .font(.system(size: 18))
                            .padding(.bottom,0.5)
                            .foregroundColor(firmware.signed ? Color.green : Color.red)
                        Text(firmware.buildid)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        let filesize = Float(firmware.filesize) / 1024 / 1024 / 1024
                        Text(String(format:"%.2f GB", filesize))
                    }
                    Image(systemName: firmware.is_downloaded ? "arrow.down.circle.fill" : "arrow.down")
                    Button(action: {
                        data_object.download_firmware(firmware: firmware)
                    }) {
                        Text("Add to Downloads")
                    }
                }
                .padding(5)
            }
        }
        .frame(minWidth:600)
    }
}

struct DeviceDetail_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetail(device: DataObject().devices.last!)
    }
}
