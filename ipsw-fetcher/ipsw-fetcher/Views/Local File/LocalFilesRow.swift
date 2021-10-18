//
//  FilesRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct LocalFilesRow: View {
    var localFile: LocalFile
    @EnvironmentObject var deviceData: DeviceData

    var body: some View {
        HStack {
            Text(localFile.name)
            Spacer()
            Button(action: {
                deviceData.delete_local_file(localFile.name)
            }) {
                Image(systemName: "x.circle")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct FilesRow_Previews: PreviewProvider {
    static var previews: some View {
        LocalFilesRow(localFile: DeviceData().local_files_iphone[0])
    }
}
