//
//  FirmwareRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct FirmwareRow: View {
    
    var firmware_version: FirmwareVersion
    
    var body: some View {
        HStack {
            Image(systemName: firmware_version.icon_name)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
            HStack {
                VStack(alignment: .leading) {
                    Text("\(firmware_version.os_name) \(firmware_version.version)")
                        .font(.title)
                }
            }
            .padding()
        }
        .padding()
    }
}

struct FirmwareRow_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareRow(firmware_version: DeviceData().firmware_versions[1])
    }
}
