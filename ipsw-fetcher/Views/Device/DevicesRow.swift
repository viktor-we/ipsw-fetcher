//
//  DevicesRow.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 12.10.21.
//

import SwiftUI

struct DevicesRow: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var device_index: Int {
        data_object.devices.firstIndex(where: { $0.identifier == device.identifier })!
    }
    
    var device: Device

    var body: some View {
        HStack {
            Image(data_object.devices[device_index].identifier)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            HStack {
                VStack(alignment: .leading) {
                    Text(data_object.devices[device_index].name)
                        .font(.system(size: 18))
                    
                }
            }
            .padding()
            Spacer()
            Button(action: {
                data_object.devices[device_index].is_favorite.toggle()
            }) {
                Image(systemName: data_object.devices[device_index].is_favorite ? "star.fill" : "star")
            }
            .buttonStyle(PlainButtonStyle())
            .font(.title)
        }
        .padding()
    }
}
