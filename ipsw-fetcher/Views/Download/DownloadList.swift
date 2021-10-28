//
//  DownloadList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import SwiftUI

struct DownloadList: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var body: some View {
        List(data_object.download_tasks,id:\.id) { task in
            DownloadRow(download_task: task)
        }
        .toolbar {
            Button (action: {
                data_object.start_every_download()
            }) {
                Text("Start all Downloads")
            }
            Button (action: {
                data_object.cancel_every_download()
            }) {
                Text("Cancel all Downloads")
            }
            Button (action: {
                data_object.delete_every_download()
            }) {
                Text("Delete all Downloads")
            }
        }
    }
}

struct DownloadList_Previews: PreviewProvider {
    static var previews: some View {
        DownloadList()
        .environmentObject(DataObject())
    }
}
