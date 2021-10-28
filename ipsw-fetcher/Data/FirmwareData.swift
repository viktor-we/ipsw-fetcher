//
//  FirmwaresData.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 17.10.21.
//

import Combine
import Foundation
import SwiftUI

final class FirmwareData: ObservableObject {
    
    @Published var firmwares = [Firmware]() {
        didSet {
            
        }
    }
    
    init() {
        
    }
    
    
}


