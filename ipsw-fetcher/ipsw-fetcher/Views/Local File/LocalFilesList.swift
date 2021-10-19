//
//  FilesList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct FilesList: View {
    
    @EnvironmentObject var deviceData: DeviceData

    var body: some View {
        List {
            Section(header:Text("iPhone Software Updates")) {
                ForEach(deviceData.local_files_iphone, id:\.id) { localFile in
                    LocalFilesRow(localFile: localFile, device_type: "iOS")
                }
            }
            Section(header:Text("iPad Software Updates")) {
                ForEach(deviceData.local_files_ipad, id:\.id) { localFile in
                    LocalFilesRow(localFile: localFile, device_type: "iPadOS")
                }
            }
        }
        .toolbar {
            Button(action: {
                deviceData.fetch_local_files()
            }) {
                Image(systemName: "arrow.triangle.2.circlepath")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct FilesList_Previews: PreviewProvider {
    static var previews: some View {
        FilesList()
    }
}
