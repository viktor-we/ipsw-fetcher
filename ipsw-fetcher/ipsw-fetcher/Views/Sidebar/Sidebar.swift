//
//  Sidebar.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct Sidebar: View {
    
    @State private var selectedSidebarOption: SidebarOption?
    
    let sidebarOptions = [SidebarOption(id: 0, title: "Devices", icon_name: "iphone"),
                          SidebarOption(id:1, title: "Firmwares", icon_name: "iphone.and.arrow.forward"),
                          SidebarOption(id: 2, title: "Files", icon_name: "doc")]
    
    var body: some View {
        NavigationView {
            List(selection: $selectedSidebarOption) {
                ForEach(sidebarOptions) { sidebarOption in
                    NavigationLink(destination: ListView(sidebarOption: sidebarOption)) {
                        SidebarRow(sidebarOption: sidebarOption)
                    }
                    .tag(sidebarOption)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth:150)
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