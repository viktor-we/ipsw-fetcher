//
//  DeviceDetail.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 16.10.21.
//

import SwiftUI

struct DeviceList: View {
    
    @EnvironmentObject var data_object: DataObject
    
    var device: Device
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(device.identifier)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    Text(device.name)
                        .font(.title)
                    Text(device.identifier)
                }
                Spacer()
            }
            .padding(.vertical,30)
            .padding()
            Text("devices_firmwares")
                .font(.title)
                .padding(.leading)
            
            List (data_object.get_firmwares_for_device(identifier: device.identifier)) { firmware in
                DeviceRow(firmware:firmware)
                    .padding(.leading,10)
                    .padding(.trailing,10)
                
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
            .environment(\.defaultMinListRowHeight, 75)
        }
        .frame(minWidth:600)
    }
}
