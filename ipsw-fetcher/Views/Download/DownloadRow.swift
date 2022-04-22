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
    
    var downloaded_size_in_gb: Float {
        Float(download_task.downloaded_size) / 1024 / 1024 / 1024
    }
    
    var filesize_in_gb: Float {
        Float(download_task.firmware.filesize) / 1024 / 1024 / 1024
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(download_task.firmware.filename)
                    .font(.system(size: 18))
                Text(String(format:"%.3f GB", filesize_in_gb))
                    .font(.caption)
            }
            Spacer()
            if(downloaded_size_in_gb > 0 && filesize_in_gb != downloaded_size_in_gb) {
                Text(String(format:"%.3f GB / %.3f GB", downloaded_size_in_gb, filesize_in_gb))
                    .font(.caption)
                ProgressView(value:download_task.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding([.leading,.trailing])
                    .frame(width:200)
                if (download_task.downloading) {
                    Button(action: {
                            download_task.pause_download()
                        }) {
                        Image(systemName: "pause.fill")
                        Text("downloads_pause")
                                .padding()
                    }
                } else {
                    Button(action: {
                            download_task.resume_download()
                        }) {
                        Image(systemName: "playpause.fill")
                        Text("downloads_resume")
                                .padding()
                    } 
                }
                Button(action: {
                        download_task.cancel_download()
                    }) {
                    Image(systemName: "x.circle.fill")
                            .foregroundColor(Color.red)
                    Text("downloads_cancel")
                            .foregroundColor(Color.red)
                            .padding()
                }
            } else if (downloaded_size_in_gb == 0) {
                Button(action: {
                    download_task.start_download()
                }) {
                    Image(systemName: "play.fill")
                    Text("downloads_start")
                        .padding()
                }
                Button(action: {
                    data_object.delete_download_task(download_task: download_task)
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(Color.red)
                    Text("downloads_remove")
                        .foregroundColor(Color.red)
                        .padding()
                }
            } else if (filesize_in_gb == downloaded_size_in_gb) {
                Text("downloads_completed")
                    .padding([.leading,.trailing])
                Button(action: {
                    data_object.delete_download_task(download_task: download_task)
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(Color.red)
                    Text("downloads_remove")
                        .foregroundColor(Color.red)
                        .padding()
                }
            }
        }
        .padding()
    }
}
