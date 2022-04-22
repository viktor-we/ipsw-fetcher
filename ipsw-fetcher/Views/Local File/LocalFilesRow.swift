//
//  FilesRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct LocalFilesRow: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var local_file: LocalFile
    var device_type: String

    var body: some View {
        HStack {
            Text(local_file.file_name)
            Spacer()
            Button(action: {
                switch device_type {
                case "iOS": data_object.delete_local_file_iphone(local_file.file_name)
                case "iPadOS": data_object.delete_local_file_ipad(local_file.file_name)
                default: print("No device type")
                }
            }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(Color.red)
                Text("files_delete")
                    .foregroundColor(Color.red)
                    .padding()
            }
        }
    }
}
