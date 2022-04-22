//
//  DeviceRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 22.04.22.
//

import SwiftUI

struct DeviceRow: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var firmware: FirmwareIndex
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(firmware.os_name) \(firmware.version)")
                    .font(.system(size: 18))
                    .padding(.bottom,0.5)
                    .foregroundColor(firmware.signed ? Color.green : Color.red)
                Text(firmware.filename)
            }
            Spacer()
            VStack(alignment: .trailing) {
                let filesize = Float(firmware.filesize) / 1024 / 1024 / 1024
                Text(String(format:"%.3f GB", filesize))
            }
            Image(systemName: firmware.is_downloaded ? "checkmark.rectangle.fill" : "xmark.rectangle")
            Button(action: {
                data_object.create_download_task(firmware: firmware)
            }) {
                Image(systemName: "plus")
                    .padding()
            }
            Button(action: {
                switch firmware.os_name {
                case "iOS": data_object.delete_local_file_iphone(firmware.filename)
                case "iPadOS": data_object.delete_local_file_ipad(firmware.filename)
                default: print("No device type")
                }
            }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(Color.red)
            }
        }
        .padding(5)
    }
}
