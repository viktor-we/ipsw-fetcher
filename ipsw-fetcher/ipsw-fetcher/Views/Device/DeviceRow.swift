//
//  iphone_model.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct DeviceRow: View {
    
    @EnvironmentObject var deviceData: DeviceData
    
    var deviceIndex: Int {
        deviceData.devices.firstIndex(where: { $0.identifier == device.identifier })!
    }
    
    var device: Device
    
    var os_name: String {
        if device.name.contains("iPhone") {
            return "iOS"
        } else if device.name.contains("iPad") {
            return "iPadOS"
        } else if device.name.contains("Mac") {
            return "macOS"
        }
        return "OS"
    }

    var body: some View {
        HStack {
            Image(device.identifier)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            HStack {
                VStack(alignment: .leading) {
                    Text(device.name)
                        .font(.title)
                    Text(device.identifier)
                    
                }
                Spacer()
                if let version = device.firmwares.first {
                    Text("\(version.os_name) \(version.version)")
                        .font(.title2)
                } else {
                    Text("No version found")
                }
                
            }
            .padding()
            Button(action: {
                deviceData.devices[deviceIndex].isFavorite.toggle()
            }) {
                Image(systemName: device.isFavorite ? "arrow.down.circle.fill" : "arrow.down.circle")
            }
            .buttonStyle(PlainButtonStyle())
            .font(.title)
        }
        .padding()
    }
}

struct DeviceRow_Previews: PreviewProvider {
    static var previews: some View {
        DeviceRow(device: DeviceData().devices.last!)
    }
}
