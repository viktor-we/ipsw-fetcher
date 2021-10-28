//
//  SidebarRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import SwiftUI

struct SidebarRow: View {
    var sidebar_option: SidebarOption
    
    var body: some View {
        HStack {
            Image (systemName: sidebar_option.icon_name)
                .font(.title)
            Text(sidebar_option.title)
        }
        .padding()
    }
}

struct SidebarRow_Previews: PreviewProvider {
    static var previews: some View {
        SidebarRow(sidebar_option: SidebarOption(id: 0, title: "Devices", icon_name: "iphone"))
    }
}
