//
//  File.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 14.10.21.
//

import Foundation

struct LocalFile: Hashable, Codable, Identifiable {
    var id = UUID()
    var file_name: String
}
