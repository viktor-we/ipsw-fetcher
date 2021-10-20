//
//  DownloadRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import SwiftUI

struct DownloadRow: View {
    
    @EnvironmentObject var data: DeviceData
    
    @State var download_task: DownloadTask
    
    @State private var progress: Double = 0.0
    
    @State private var observer: NSKeyValueObservation?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(download_task.filename)
                Text(String(format:"%.2f GB", Float(download_task.filesize) / 1024 / 1024 / 1024))
                    .font(.caption)
            }
            Spacer()
            Button(action: {
                if (download_task.downloading) {
                    observer?.invalidate()
                    download_task.cancel_download()
                    progress = 0.0
                } else {
                    download_task.resume_download()
                    observer = download_task.task?.progress.observe(\.fractionCompleted) { download_progress, _ in
                        DispatchQueue.main.async {
                            self.progress = download_progress.fractionCompleted
                        }
                    }
                }
            }) {
                Text(download_task.downloading ? "Cancel Download" : "Start Download")
            }
            Button(action: {
                data.delete_download(download_task: download_task)
            }) {
                Text("Delete Download")
            }
            ProgressView(value:progress)
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }
        .onAppear {
            if (download_task.downloading) {
                observer = download_task.task?.progress.observe(\.fractionCompleted) { download_progress, _ in
                    DispatchQueue.main.async {
                        self.progress = download_progress.fractionCompleted
                    }
                }
            }
        }
    }
}

struct DownloadRow_Previews: PreviewProvider {
    static var previews: some View {
        //DownloadRow()
        Text("")
    }
}
