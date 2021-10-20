//
//  DownloadTask.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import Foundation

final class DownloadTask {
    var id = UUID()
    var filename: String
    var filesize: Int
    var url: URL
    var os_name: String
    
    var task: URLSessionDownloadTask?
    var observer: NSKeyValueObservation?
    var downloading = false
    
    init(filename: String, filesize: Int, url: URL, os_name: String) {
        self.filename = filename
        self.filesize = filesize
        self.url = url
        self.os_name = os_name
        create_task()
    }
    
    func create_task() {
        var save_path = local_files_itunes_path
        if os_name == "iOS" {
            save_path = local_files_iphone_path
        } else if os_name == "iPadOS" {
            save_path = local_files_ipad_path
        }
        task = URLSession.shared.downloadTask(with: self.url) { local_url, url_resonse, error in
            if let local_url = local_url {
                do {
                    try fm.copyItem(at: local_url, to: save_path.appendingPathComponent(self.filename))
                } catch {
                    print("could not copy")
                }
            }
        }
    }
    
    func resume_download() {
        self.downloading = true
        self.task?.resume()
    }
    
    func cancel_download() {
        self.downloading = false
        self.task?.cancel()
        self.create_task()
    }
}
