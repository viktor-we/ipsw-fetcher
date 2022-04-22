//
//  FirmwareDetail.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 17.10.21.
//

import SwiftUI

struct FirmwareList: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var firmware_version: FirmwareVersion
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Image(systemName: firmware_version.icon_name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    Text("\(firmware_version.os_name) \(firmware_version.version)")
                        .font(.title)
                    Text("\(firmware_version.buildid)")
                }
                .padding()
                Spacer()
                Button(action: {
                    for firmware in (data_object.get_firmwares_for_version(version: firmware_version.version, os_name: firmware_version.os_name)) { 
                        data_object.create_download_task(firmware: firmware)
                    }
                }) {
                    Image(systemName: "plus")
                    Text("firmwares_add_all")
                        .padding()
                }
                Button(action: {
                    for firmware in (data_object.get_firmwares_for_version(version: firmware_version.version, os_name: firmware_version.os_name)) {
                        if (firmware.os_name == "iOS") {
                            data_object.delete_local_file_iphone(firmware.filename)
                        } else if (firmware.os_name == "iPadOS") {
                            data_object.delete_local_file_ipad(firmware.filename)
                        }
                    }
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(Color.red)
                    Text("firmwares_delete_all")
                        .padding()
                        .foregroundColor(Color.red)
                }
            }
            .padding(.vertical,30)
            .padding()
            Text("firmwares_used_by")
                .font(.title)
                .padding()
            List {
                ForEach(data_object.get_firmwares_for_version(version: firmware_version.version, os_name: firmware_version.os_name), id: \.identifier) { firmware in
                    FirmwareRow(firmware:firmware)
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
