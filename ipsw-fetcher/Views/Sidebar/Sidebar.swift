//
//  Sidebar.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct Sidebar: View {
    
    @EnvironmentObject var data_object: DataObject
    
    @State private var selected_sidebar_option: SidebarOption?
    
    let sidebar_options = [SidebarOption(id: 0, title: "sidebar_option_devices", icon_name: "iphone"),
                          SidebarOption(id: 1, title: "sidebar_option_firmwares", icon_name: "shippingbox"),
                          SidebarOption(id: 2, title: "sidebar_option_files", icon_name: "doc"),
                          SidebarOption(id: 3, title: "sidebar_option_downloads", icon_name: "arrow.down.app")]
    
    var body: some View {
        NavigationView {
            List(selection: $selected_sidebar_option) {
                ForEach(sidebar_options) { sidebar_option in
                    NavigationLink(destination: Content(sidebar_option: sidebar_option)) {
                        HStack {
                            Image (systemName: sidebar_option.icon_name)
                                .font(.title)
                            Text(LocalizedStringKey(sidebar_option.title))
                            Spacer()
                            if (sidebar_option.id == 3) {
                                Text(String(data_object.download_tasks.count))
                                    .bold()
                            }
                        }
                        .padding()
                    }
                    .tag(sidebar_option)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(width:200)
            .toolbar {
                Text("")
            }
        }
        .navigationTitle("IPSW Fetcher")
        .frame(minWidth:1200,minHeight: 600)
    }
}
