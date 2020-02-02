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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connection = Connection()
        connection.searchService()
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

