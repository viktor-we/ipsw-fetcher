//
//  ipsw_fetcherApp.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

@main
struct ipsw_fetcherApp: App {
    @StateObject private var deviceData = DataObject()

    var body: some Scene {
        WindowGroup {
            Sidebar()
                .environmentObject(deviceData)
        }
    }
}
