//
//  DownloadList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import SwiftUI

struct DownloadsList: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var body: some View {
        List {
            ForEach(data_object.download_tasks, id:\.id) { task in
                DownloadRow(download_task: task)
                    .listRowBackground((task.index  % 2 == 0) ? Color(.clear) : color_grey)
                    .padding(5)
                    .padding(.leading,10)
                    .padding(.trailing,10)
            }
        }
        .toolbar {
            Button (action: {
                data_object.start_next_download()
            }) {
                Text("downloads_start_all")
            }
            Button (action: {
                data_object.pause_every_download()
            }) {
                Text("downloads_pause_all")
            }
            Button (action: {
                data_object.delete_completed_downloads()
            }) {
                Text("downloads_remove_completed")
            }
            Button (action: {
                data_object.delete_every_download()
            }) {
                Text("downloads_remove_all")
                    .foregroundColor(Color.red)
            }
        }
    }
}
