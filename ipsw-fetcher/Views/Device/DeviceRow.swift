//
//  DeviceRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 22.04.22.
//

import SwiftUI

struct DeviceRow: View {
    
    @EnvironmentObject var data_object: DataObject
    
    @State private var hovered = false
    
    var firmware: Firmware
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(firmware.os_name) \(firmware.version)")
                    .font(.system(size: 18))
                    .padding(.bottom,0.5)
                    .foregroundColor(firmware.signed ? Color.green : Color.red)
                Text(firmware.filename)
                    .textSelection(.enabled)
            }
            Spacer()
            if (hovered) {
                Button(action: {
                    data_object.create_download_task(firmware: firmware)
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal,10)
                Button(action: {
                    data_object.delete_local_file(filename: firmware.filename)
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(Color.red)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal,10)
            }
            VStack(alignment: .trailing) {
                let filesize = Float(firmware.filesize) / 1024 / 1024 / 1024
                Text(String(format:"%.3f GB", filesize))
            }
            Image(systemName: firmware.is_downloaded ? "checkmark.rectangle.fill" : "xmark.rectangle")
            
        }
        .onHover { isHovered in
            self.hovered = isHovered
        }
        .padding(5)
    }
}
