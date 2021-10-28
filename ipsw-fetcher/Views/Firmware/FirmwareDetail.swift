//
//  FirmwareDetail.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 17.10.21.
//

import SwiftUI

struct FirmwareDetail: View {
    
    @EnvironmentObject var data_object: DataObject
    
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
                    for firmware in (data_object.get_firmwares_for_version(version: firmware_version.version, os_name: firmware_version.os_name)) { 
                        data_object.download_firmware(firmware: firmware)
                    }
                }) {
                    Text("Add all")
                }
            }
            .padding()
            Text("Used by:")
                .font(.title)
                .padding()
            List(data_object.get_firmwares_for_version(version: firmware_version.version, os_name: firmware_version.os_name), id: \.identifier) { firmware in
                HStack {
                    VStack(alignment: .leading) {
                        Text(firmware.device_name)
                            .font(.system(size: 18))
                            .padding(.bottom,0.5)
                        Text(firmware.filename)
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

struct FirmwareDetail_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareDetail(firmware_version: DataObject().firmware_versions.first!)
    }
}
