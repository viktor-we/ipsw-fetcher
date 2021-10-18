//
//  ListView.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct ListView: View {
    var sidebarOption: SidebarOption
    var body: some View {
        if(sidebarOption.id == 0) {
            DevicesList()
        } else if (sidebarOption.id == 1) {
            FirmwaresList()
        } else if (sidebarOption.id == 2){
            FilesList()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(sidebarOption: SidebarOption(id: 0, title: "Devices", icon_name: "iphone"))
    }
}
