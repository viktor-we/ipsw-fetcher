//
//  Sidebar.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct Sidebar: View {
    
    @State private var selected_sidebar_option: SidebarOption?
    
    let sidebar_options = [SidebarOption(id: 0, title: "Devices", icon_name: "iphone"),
                          SidebarOption(id: 1, title: "Firmwares", icon_name: "shippingbox"),
                          SidebarOption(id: 2, title: "Local Files", icon_name: "doc"),
                          SidebarOption(id: 3, title: "Downloads", icon_name: "arrow.down.app")]
    
    var body: some View {
        NavigationView {
            List(selection: $selected_sidebar_option) {
                ForEach(sidebar_options) { sidebar_option in
                    NavigationLink(destination: ListView(sidebar_option: sidebar_option)) {
                        SidebarRow(sidebar_option: sidebar_option)
                    }
                    .tag(sidebar_option)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth:200)
            .toolbar {
                Text("")
            }
        }
        .navigationTitle("IPSW Fetcher")
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
