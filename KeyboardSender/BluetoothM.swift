//
//  BluetoothM.swift
//  KeyboardSender
//
//  Created by KEISUKE MASUDA on 2020/01/31.
//  Copyright © 2020 KEISUKE MASUDA. All rights reserved.
//

import Foundation
import CoreBluetooth

class BTMannager: NSObject {
    var manager: CBCentralManager
    private var peripheral: CBPeripheral? = nil
    
    override init() {
        manager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        manager.delegate = self
    }
}

extension BTMannager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            manager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print()
        }
    }
    
    
}
