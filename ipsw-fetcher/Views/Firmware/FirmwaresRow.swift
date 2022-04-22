//
//  FirmwareRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct FirmwaresRow: View {
    
    var firmware_version: FirmwareVersion
    
    var body: some View {
        HStack {
            Image(systemName: firmware_version.icon_name)
                .font(.system(size: 50))
                .scaledToFill()
                .frame(width: 50, height: 50)
            HStack {
                VStack(alignment: .leading) {
                    Text("\(firmware_version.os_name) \(firmware_version.version)")
                        .font(.system(size: 18))
                }
            }
            .padding()
        }
        .padding()
    }
}
