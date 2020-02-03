//
//  MoniterManager.swift
//  KeyboardSender
//
//  Created by KEISUKE MASUDA on 2020/02/04.
//  Copyright © 2020 KEISUKE MASUDA. All rights reserved.
//

import Foundation
import Cocoa

protocol MonitorClass {
    func dataSend(event: NSEvent?,_ mode: NSEvent.EventTypeMask)
}

class MonitorManager {
    var monitors:[MonitorObject] = []
    var connection: Connection
    
    init(_ connection: Connection) {
        self.connection = connection
        setup()
    }
    
    private func setup() {
        let mouseMoved = mouseMovedMonitor(mode: .mouseMoved, connection: connection )
        monitors.append(mouseMoved)
        
        let mouseLeftPushed = mouseLeftPress(mode: .leftMouseDown, connection: connection)
        monitors.append(mouseLeftPushed)
    }
    
}

class MonitorObject {
    var monitor: Any!
    var connection: Connection!
    init(mode: NSEvent.EventTypeMask, connection: Connection) {
        self.connection = connection
        setup(mode)
    }
    
    private func setup(_ mode: NSEvent.EventTypeMask) {
        monitor = NSEvent.addLocalMonitorForEvents(matching: mode) { (event) -> NSEvent? in
            DispatchQueue.global(qos: .userInteractive).async {
                self.dataSend(event: event, mode)
            }
            
            return event
        }
    }
    
    func dataSend(event: NSEvent?, _ mode: NSEvent.EventTypeMask){
        
    }
    
}



