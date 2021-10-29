//
//  DownloadTask.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import Foundation

class DownloadTask: NSObject, ObservableObject {
    
    var id = UUID()
    var firmware: Firmware
    
    private lazy var urlSession = URLSession(configuration: .default, delegate: self,  delegateQueue: nil)
    
    private var download_task: URLSessionDownloadTask?
    
    @Published var downloading = false
    @Published var completed = false
    @Published var progress = 0.0
    @Published var downloaded_size = 0
    
    var save_path: URL {
        if firmware.os_name == "iOS" {
            return local_files_iphone_path
        } else {
            return local_files_ipad_path
        }
    }
    
    init(firmware: Firmware) {
        self.firmware = firmware
        super.init()
        create_task()
    }
    
    func create_task() {
        let downloadTask = urlSession.downloadTask(with: firmware.url)
        self.download_task = downloadTask
    }
    
    func resume_download() {
        self.downloading = true
        self.download_task?.resume()
    }
    
    func cancel_download() {
        self.downloading = false
        self.download_task?.cancel()
        self.download_task = nil
        self.progress = 0.0
        self.downloaded_size = 0
        self.create_task()
    }
    
}

extension DownloadTask: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let calculated_progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.progress = calculated_progress
            self.downloaded_size = Int(totalBytesWritten)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.completed = true
            self.downloading = false
        }
        do {
            try fm.moveItem(at: location, to: save_path.appendingPathComponent(self.firmware.filename))
        } catch {
            print("could not copy")
        }
    }
    
}
