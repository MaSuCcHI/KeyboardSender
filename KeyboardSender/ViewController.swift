//
//  ViewController.swift
//  KeyboardSender
//
//  Created by KEISUKE MASUDA on 2020/01/31.
//  Copyright © 2020 KEISUKE MASUDA. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var connection: Connection!
    var mouseMonitor: Any?
    var keyMonitor: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connection = Connection()
        connection.searchService()
        
        mouseMonitor = NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.mouseMoved) { (event) -> NSEvent? in
            DispatchQueue.main.async {
                print("pressure: \(round(100 * event.pressure) / 100)")
//                print("x:\(event.absoluteX),y:\(event.absoluteY)")
                print(event.deltaY)
                print(event.deltaX)
                self.connection.sendData(data:"\(event.deltaX),\(event.deltaY)".data(using: .utf8)!, type: .mouse)
            }
            return event
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        let data = Data(base64Encoded: "成功", options: .ignoreUnknownCharacters)
        connection.sendData(data: Data(base64Encoded: "成功") ?? data!, type: .keyboard)
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

