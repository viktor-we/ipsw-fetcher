//
//  ipsw_fetcherApp.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

@main
struct ipsw_fetcherApp: App {
    @StateObject private var deviceData = DeviceData()

    var body: some Scene {
        WindowGroup {
            Sidebar()
                .frame(minWidth: 900, minHeight: 500)
                .environmentObject(deviceData)
        }
    }
}
