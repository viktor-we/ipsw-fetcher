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
            VStack(alignment: .leading) {
                Text(download_task.filename)
                    .font(.system(size: 18))
                Text(String(format:"%.2f GB", Float(download_task.filesize) / 1024 / 1024 / 1024))
                    .font(.caption)
            }
            Spacer()
            if (download_task.downloading) {
                Text(String(format:"%.3f GB / %.3f GB", Float(download_task.downloaded_size) / 1024 / 1024 / 1024, Float(download_task.filesize) / 1024 / 1024 / 1024))
                    .font(.caption)
                ProgressView(value:download_task.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding([.leading,.trailing])
                    .frame(width:200)
            }
            Button(action: {
                if (download_task.downloading) {
                    download_task.cancel_download()
                } else {
                    download_task.resume_download()
                }
            }) {
                Text(download_task.downloading ? "Cancel Download" : "Start Download")
            }
            Button(action: {
                data_object.delete_download(download_task: download_task)
            }) {
                Text("Delete from list")
            }
        }
        .padding()
    }
}

struct DownloadRow_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value:0.5)
            .progressViewStyle(CircularProgressViewStyle())
            .padding([.leading,.trailing])
    }
}
