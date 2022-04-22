//
//  DownloadTask.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import Foundation
import SwiftUI

class DownloadTask: NSObject, ObservableObject {
    
    var id = UUID()
    var firmware: FirmwareIndex
    var resume_data: Data?
    var data_object: DataObject
    var bulk_download: Bool = false
    var index: Int
    
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
    
    init(firmware: FirmwareIndex, data_object: DataObject, index: Int) {
        self.firmware = firmware
        self.data_object = data_object
        self.index = index
        super.init()
    }
    
    func start_download() {
        if self.downloaded_size > 0 {
            self.resume_download()
        } else {
            let downloadTask = urlSession.downloadTask(with: firmware.url)
            self.download_task = downloadTask
            self.downloading = true
            self.download_task?.resume()
        }
    }
    
    func pause_download() {
        self.download_task?.cancel{ resume_data_or_nil in
            guard let resume_data = resume_data_or_nil else {
                print("Could not be resumed")
                return
            }
            self.resume_data = resume_data
        }
        self.downloading = false
    }
    
    func resume_download() {
        guard let resume_data = self.resume_data else {
            print("Could not be resumed")
            return
        }
        let downloadTask = urlSession.downloadTask(withResumeData: resume_data)
        self.download_task = downloadTask
        self.download_task?.resume()
        self.downloading = true
    }
    
    func cancel_download() {
        DispatchQueue.main.async {
            self.progress = 0.0
            self.downloaded_size = 0
            self.downloading = false
        }
        self.download_task?.cancel()
        self.download_task = nil
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
            self.data_object.fetch_local_files()
            self.data_object.alert_finished_download(filename: self.firmware.filename)
            if (self.bulk_download) {
                self.data_object.start_next_download()
            }
        }
        do {
            try fm.moveItem(at: location, to: save_path.appendingPathComponent(self.firmware.filename))
        } catch {
            print("could not copy")
        }
    }
    
}
