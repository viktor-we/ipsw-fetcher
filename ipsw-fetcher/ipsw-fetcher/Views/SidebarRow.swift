//
//  SidebarRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct SidebarRow: View {
    var sidebarOption: SidebarOption
    
    var body: some View {
        HStack {
            Image (systemName: sidebarOption.icon_name)
                .font(.title)
            Text(sidebarOption.title)
        }
        .padding()
    }
}

struct SidebarRow_Previews: PreviewProvider {
    static var previews: some View {
        SidebarRow(sidebarOption: SidebarOption(id: 0, title: "Devices", icon_name: "iphone"))
    }
}
