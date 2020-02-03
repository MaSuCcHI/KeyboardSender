//
//  BTmanager.swift
//  KeyboardSender
//
//  Created by KEISUKE MASUDA on 2020/01/31.
//  Copyright © 2020 KEISUKE MASUDA. All rights reserved.
//

import Foundation
import CoreBluetooth



class BTmanager: NSObject {
    var manager: CBCentralManager
    private var services: [CBService] = []
    private var characteristics: [CBCharacteristic]? = nil
    private var connectedPeripheral: CBPeripheral? = nil
    
    
    override init() {
        manager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        manager.delegate = self
        
    }
    
    func sendConrollData(_ type: ControllType) {
        let data = Data()
        guard let peripheral = self.connectedPeripheral else {
            return
        }
        switch type {
        case .mouse:
            print()
            guard let charactaristic = characteristics?.first(where: {$0.uuid == Const.Bluetooth.mouseUUID}) else { return }
            peripheral.writeValue(data, for: charactaristic, type: .withResponse)
        case .keyboard:
            print()
            guard let charactaristic = characteristics?.first(where: {$0.uuid == Const.Bluetooth.keyboardUUID}) else { return }
            peripheral.writeValue(data, for: charactaristic, type: .withResponse)
        default:
            print("設定されていないデータを送ろうとしています．")
        }
        
    }
    
    
}

extension BTmanager:CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print()
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .unauthorized:
            print()
        default:
            print()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "Controller" {
            print(peripheral.name)
            let passHash = 111
            self.connectedPeripheral = peripheral
            central.connect(peripheral, options: ["passwardHash":passHash])
            manager.stopScan()
        }
        print(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        print("Connect Success")
        manager.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connect Failed \(error.debugDescription)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnect")
        manager.scanForPeripherals(withServices: [Const.Bluetooth.serviceUUID], options: nil)
    }
    
}

extension BTmanager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print(error)
            return
        }
        
        services = peripheral.services!
        characteristics = services.first?.characteristics
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let error = error else {
            print("write OK")
            return
        }
        print("データの書き込みが失敗しました．\(error)")
    }
    
}
