//
//  ListView.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct Content: View {
    
    var sidebar_option: SidebarOption
    
    var body: some View {
        if(sidebar_option.id == 0) {
            DevicesList()
        } else if (sidebar_option.id == 1) {
            FirmwaresList()
        } else if (sidebar_option.id == 2){
            FilesList()
        } else if (sidebar_option.id == 3){
            DownloadsList()
        }
    }
}
