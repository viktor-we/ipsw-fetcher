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
                Text(deviceData.get_latest_firmware_for_device(identifier: device.identifier))
                    .font(.title2)
            }
            .padding()
            Button(action: {
                deviceData.devices[deviceIndex].isFavorite.toggle()
            }) {
                Image(systemName: device.isFavorite ? "star.fill" : "star")
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
