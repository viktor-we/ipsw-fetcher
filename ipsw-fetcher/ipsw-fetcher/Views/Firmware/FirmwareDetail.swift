//
//  FirmwareDetail.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 17.10.21.
//

import SwiftUI

struct FirmwareDetail: View {
    
    @EnvironmentObject var deviceData: DeviceData
    
    var firmware_version: FirmwareVersion
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Image(systemName: firmware_version.icon_name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                Text("\(firmware_version.os_name) \(firmware_version.version)")
                    .font(.title)
                Spacer()
                Button(action: {
                    for firmware in (deviceData.get_firmwares_for_version(version: firmware_version.version, os_name: firmware_version.os_name)) { 
                        deviceData.download_firmware(firmware: firmware)
                    }
                }) {
                    Text("Download Firmwares")
                }
            }
            .padding()
            Text("Used by:")
                .font(.title)
                .padding()
            List(deviceData.get_firmwares_for_version(version: firmware_version.version, os_name: firmware_version.os_name), id: \.identifier) { firmware in
                HStack {
                    VStack(alignment: .leading) {
                        Text(firmware.device_name)
                            .font(.title)
                            .padding(.bottom,0.5)
                        Text(firmware.buildid)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        let filesize = Float(firmware.filesize) / 1024 / 1024 / 1024
                        Text(String(format:"%.2f GB", filesize))
                        Text(firmware.filename)
                    }
                    if (firmware.is_downloaded) {
                        Image(systemName: "arrow.down.to.line.compact")
                    } else {
                        Image(systemName: "arrow.down")
                    }
                }
                .padding(.bottom,5)
            }
        }
        .frame(minWidth:400)
    }
}

struct FirmwareDetail_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareDetail(firmware_version: DeviceData().firmware_versions.first!)
    }
}
