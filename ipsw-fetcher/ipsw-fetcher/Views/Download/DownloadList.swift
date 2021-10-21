//
//  DownloadList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import SwiftUI

struct DownloadList: View {
    
    @EnvironmentObject var device_data: DeviceData
    
    var body: some View {
        List(device_data.download_tasks,id:\.id) { task in
            DownloadRow(download_task: task)
        }
        .toolbar {
            Button (action: {
                device_data.start_every_download()
            }) {
                Text("Start all Downloads")
            }
            Button (action: {
                device_data.cancel_every_download()
            }) {
                Text("Cancel all Downloads")
            }
            Button (action: {
                device_data.delete_every_download()
            }) {
                Text("Delete all Downloads")
            }
        }
    }
}

struct DownloadList_Previews: PreviewProvider {
    static var previews: some View {
        DownloadList()
        .environmentObject(DeviceData())
    }
}
