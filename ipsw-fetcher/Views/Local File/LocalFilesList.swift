//
//  FilesList.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct FilesList: View {
    
    @EnvironmentObject var data_object: DataObject
    
    @State private var text_field = ""
    
    var filtered_files_iphone : [LocalFile] {
        data_object.local_files_iphone.filter({ local_file in
            (text_field == "" || local_file.file_name.lowercased().contains(text_field.lowercased()))
        })
    }
    
    var filtered_files_ipad : [LocalFile] {
            data_object.local_files_ipad.filter({ local_file in
                (text_field == "" || local_file.file_name.lowercased().contains(text_field.lowercased()))
            })
        }

    var body: some View {
        List {
            Section(header:Text("files_ios")) {
                ForEach(filtered_files_iphone, id:\.id) { localFile in
                    LocalFilesRow(local_file: localFile, device_type: "iOS")
                        .listRowBackground((localFile.index  % 2 == 0) ? Color(.clear) : color_grey)
                        .padding(5)
                        .padding(.leading,10)
                        .padding(.trailing,10)
                }
            }
        }
        List {
            Section(header:Text("files_ipados")) {
                ForEach(filtered_files_ipad, id:\.id) { localFile in
                    LocalFilesRow(local_file: localFile, device_type: "iPadOS")
                }
            }
        }
        .toolbar {
            SearchBar(text: $text_field)
            Button(action: {
                data_object.fetch_local_files()
            }) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
}
