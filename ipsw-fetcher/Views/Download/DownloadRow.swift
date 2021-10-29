//
//  DownloadRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import SwiftUI

struct DownloadRow: View {
    
    @EnvironmentObject var data_object: DataObject
    
    @ObservedObject var download_task: DownloadTask
    
    var body: some View {
        HStack {
            let filesize_in_gb = Float(download_task.firmware.filesize) / 1024 / 1024 / 1024
            let downloaded_size_in_gb = Float(download_task.downloaded_size) / 1024 / 1024 / 1024
            VStack(alignment: .leading) {
                Text(download_task.firmware.filename)
                    .font(.system(size: 18))
                Text(String(format:"%.2f GB", filesize_in_gb))
                    .font(.caption)
            }
            Spacer()
            if (download_task.downloading) {
                Text(String(format:"%.3f GB / %.3f GB", downloaded_size_in_gb, filesize_in_gb))
                    .font(.caption)
                ProgressView(value:download_task.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding([.leading,.trailing])
                    .frame(width:200)
            }
            if !download_task.completed {
                Button(action: {
                    if (download_task.downloading) {
                        download_task.cancel_download()
                    } else {
                        download_task.resume_download()
                    }
                }) {
                    Text(download_task.downloading ? "Cancel Download" : "Start Download")
                }
            } else {
                Text("Completed")
                    .padding([.leading,.trailing])
            }
            
            Button(action: {
                data_object.delete_download_task(download_task: download_task)
            }) {
                Text("Delete from list")
            }
        }
        .padding()
    }
}
