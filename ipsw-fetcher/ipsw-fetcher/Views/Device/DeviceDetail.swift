//
//  DeviceDetail.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 16.10.21.
//

import SwiftUI

struct DeviceDetail: View {
    
    var device: Device
    
    var os_name: String {
        if device.name.contains("iPhone") {
            return "iOS"
        } else if device.name.contains("iPod") {
            return "iPadOS"
        } else if device.name.contains("iPad") {
            return "iPadOS"
        } else if device.name.contains("Mac") {
            return "macOS"
        } else if device.name.contains("Apple TV") {
            return "tvOS"
        } else if device.name.contains("HomePod") {
            return "audioOS"
        }
        return "OS"
    }
    
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
                VStack(alignment: .leading) {
                    Text("Current \(device.os_name) version:")
                    if let version = device.firmwares.first?.version {
                        Text("\(device.os_name) \(version)")
                            .font(.title)
                    } else {
                        Text("No version found")
                    }
                }
            }
            .padding()
            Text("Firmwares:")
                .font(.title)
                .padding(.leading)
            List(device.firmwares, id: \.buildid) { firmware in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(device.os_name) \(firmware.version)")
                            .font(.title)
                            .padding(.bottom,0.5)
                            .foregroundColor(firmware.signed ? Color.green : Color.red)
                        Text(firmware.buildid)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        let filesize = Float(firmware.filesize) / 1024 / 1024 / 1024
                        Text(String(format:"%.2f GB", filesize))
                        Text(String(firmware.url.split(separator:"/").last!))
                    }
                }
                .padding(.bottom,5)
            }
        }
    }
}

struct DeviceDetail_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetail(device: DeviceData().devices.last!)
    }
}
