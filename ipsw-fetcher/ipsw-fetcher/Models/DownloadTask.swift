//
//  DownloadTask.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import Foundation

final class DownloadTask: ObservableObject {
    var id = UUID()
    var filename: String
    var filesize: Int
    var url: URL
    var os_name: String
    
    var task: URLSessionDownloadTask?
    var observer: NSKeyValueObservation?
    
    @Published var downloading = false
    @Published var progress = 0.0
    @Published var downloaded_size = 0
    
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
                    try fm.moveItem(at: local_url, to: save_path.appendingPathComponent(self.filename))
                } catch {
                    print("could not copy")
                }
            }
        }
        observer = task?.progress.observe(\.fractionCompleted) { download_progress, _ in
            DispatchQueue.main.async {
                self.progress = download_progress.fractionCompleted
                self.downloaded_size = Int(Double(self.filesize) * self.progress)
            }
        }
    }
    
    func resume_download() {
        self.downloading = true
        self.task?.resume()
    }
    
    func cancel_download() {
        self.downloading = false
        self.observer = nil
        self.task?.cancel()
        self.task = nil
        self.progress = 0.0
        self.create_task()
    }
}
