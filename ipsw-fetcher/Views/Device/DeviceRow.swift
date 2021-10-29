//
//  iphone_model.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct DeviceRow: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var device_index: Int {
        data_object.devices.firstIndex(where: { $0.identifier == device.identifier })!
    }
    
    var device: Device

    var body: some View {
        HStack {
            Image(device.identifier)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            HStack {
                VStack(alignment: .leading) {
                    Text(device.name)
                        .font(.system(size: 18))
                    Text(device.identifier)
                    
                }
            }
            .padding()
            Spacer()
            Button(action: {
                data_object.devices[device_index].is_favorite.toggle()
            }) {
                Image(systemName: device.is_favorite ? "star.fill" : "star")
            }
            .buttonStyle(PlainButtonStyle())
            .font(.title)
        }
        .padding()
    }
}

struct DeviceRow_Previews: PreviewProvider {
    static var previews: some View {
        DeviceRow(device: DataObject().devices.last!)
    }
}
