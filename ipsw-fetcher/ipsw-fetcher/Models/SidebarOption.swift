//
//  Sidebar.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 13.10.21.
//

import Foundation

struct SidebarOption: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var icon_name: String
}
