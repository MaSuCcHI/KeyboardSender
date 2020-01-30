//
//  ViewController.swift
//  KeyboardSender
//
//  Created by KEISUKE MASUDA on 2020/01/31.
//  Copyright © 2020 KEISUKE MASUDA. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var btManager:BTmanager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btManager = BTmanager()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

