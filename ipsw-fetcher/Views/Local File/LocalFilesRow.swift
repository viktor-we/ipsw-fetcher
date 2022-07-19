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
                data_object.delete_local_file(filename: local_file.file_name)
            }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(Color.red)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal,10)
        }
    }
}
