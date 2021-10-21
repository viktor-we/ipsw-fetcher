//
//  FilesRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct LocalFilesRow: View {
    var localFile: LocalFile
    var device_type: String
    @EnvironmentObject var deviceData: DeviceData

    var body: some View {
        HStack {
            Text(localFile.name)
            Spacer()
            Button(action: {
                switch device_type {
                case "iOS": deviceData.delete_local_file_iphone(localFile.name)
                case "iPadOS": deviceData.delete_local_file_ipad(localFile.name)
                default: print("No device type")
                }
            }) {
                Text("Delete File")
            }
        }
    }
}

struct FilesRow_Previews: PreviewProvider {
    static var previews: some View {
        LocalFilesRow(localFile: DeviceData().local_files_iphone[0], device_type: "iOS")
    }
}
