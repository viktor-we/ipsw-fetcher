//
//  DownloadTask.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 20.10.21.
//

import Foundation
import SwiftUI

class DownloadTask: NSObject, Identifiable, ObservableObject {
    
    var id = UUID()
    var firmware: Firmware
    var resume_data: Data?
    var data_object: DataObject
    var bulk_download: Bool = false
    var index: Int
    
    var time_start: DispatchTime?
    @Published var time_left = 0
    var last_update: DispatchTime?
    
    private lazy var urlSession = URLSession(configuration: .default, delegate: self,  delegateQueue: nil)
    
    private var download_task: URLSessionDownloadTask?
    
    @Published var downloading = false
    @Published var completed = false
    @Published var progress = 0.0
    @Published var downloaded_size = 0
    
    var save_path: URL {
        if firmware.filename.contains("iPhone") {
            return local_files_iphone_path
        } else if firmware.filename.contains("iPad") {
            return local_files_ipad_path
        } else {
            return local_files_itunes_path
        }
    }
    
    init(firmware: Firmware, data_object: DataObject, index: Int) {
        self.firmware = firmware
        self.data_object = data_object
        self.index = index
        super.init()
    }
    
    func start_download() {
        if self.downloaded_size > 0 {
            self.resume_download()
            self.time_start = DispatchTime.now()
        } else {
            let downloadTask = urlSession.downloadTask(with: firmware.url)
            self.download_task = downloadTask
            self.downloading = true
            self.download_task?.resume()
            self.time_start = DispatchTime.now()
            self.last_update = DispatchTime.now() - 1*1000*1000*1000
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
        self.time_left = 0
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
        self.time_start = DispatchTime.now()
        self.last_update = DispatchTime.now()
    }
    
    func cancel_download() {
        DispatchQueue.main.async {
            self.progress = 0.0
            self.downloaded_size = 0
            self.downloading = false
        }
        self.download_task?.cancel()
        self.download_task = nil
        self.time_left = 0
    }
    
}

extension DownloadTask: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let calculated_progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        let elapsed_time = (DispatchTime.now().uptimeNanoseconds - self.time_start!.uptimeNanoseconds) / 1000000
        let average_bytes_per_milsec = Double(totalBytesWritten) / Double(elapsed_time)
        let left_time = ((Double(totalBytesExpectedToWrite) - Double(totalBytesWritten)) / average_bytes_per_milsec) / 1000
        DispatchQueue.main.async {
            self.progress = calculated_progress
            if ((DispatchTime.now().uptimeNanoseconds - self.last_update!.uptimeNanoseconds) / 1000000000 > 1) {
                self.time_left = Int(left_time)
                self.last_update = DispatchTime.now()
            }
            self.downloaded_size = Int(totalBytesWritten)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            try fm.moveItem(at: location, to: save_path.appendingPathComponent(self.firmware.filename))
        } catch {
            print("could not copy")
        }
        DispatchQueue.main.async {
            self.completed = true
            self.downloading = false
            self.data_object.fetch_local_files()
            self.data_object.alert_finished_download(filename: self.firmware.filename)
            if (self.bulk_download) {
                self.data_object.start_next_download()
            }
        }
    }
    
}
