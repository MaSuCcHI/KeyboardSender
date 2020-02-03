//
//  Mouse.swift
//  KeyboardSender
//
//  Created by KEISUKE MASUDA on 2020/02/04.
//  Copyright © 2020 KEISUKE MASUDA. All rights reserved.
//

import Foundation
import Cocoa

class mouseMovedMonitor: MonitorObject {
    override func dataSend(event: NSEvent?, _ mode: NSEvent.EventTypeMask) {
        guard let event = event else {
            return
        }
        print("x:\(event.deltaX)")
        print("y:\(event.deltaY)")
        
        connection.sendData(data:"\(event.deltaX),\(event.deltaY)".data(using: .utf8)!, type: .mouse)
    }
}
 
class mouseLeftPress: MonitorObject {
    override func dataSend(event: NSEvent?, _ mode: NSEvent.EventTypeMask) {
        guard let event = event else {
            return
        }
        print("button:\(event)")
        connection.sendData(data: "leftP".data(using: .utf8)!, type: .mouse)
        
    }
}
