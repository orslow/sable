//
//  ViewController.swift
//  sable
//
//  Created by jueon on 2021/01/06.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var LeftImage: NSImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func mouseDown(with event: NSEvent) {
        // print("MouseClicked")
    }

    var begin_x: CGFloat = 0.0, begin_y: CGFloat = 0.0, end_x: CGFloat = 0.0, end_y: CGFloat = 0.0
    override func rightMouseDown(with event: NSEvent) {
        let position = event.locationInWindow.self
        begin_x = position.x
        begin_y = position.y
        print(begin_x, begin_y)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        let position = event.locationInWindow.self
        end_x = position.x
        end_y = position.y
        print(end_x - begin_x, end_y - begin_y)
        keyPress()
    }
    
    func keyPress() {
        let eventSource = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let key: CGKeyCode = 0
        let eventDown = CGEvent(keyboardEventSource: eventSource, virtualKey: key, keyDown: true)
        let eventUp = CGEvent(keyboardEventSource: eventSource, virtualKey: key, keyDown: false)
        let location = CGEventTapLocation.cghidEventTap
        eventDown?.post(tap: location)
        eventUp?.post(tap: location)
    }
    
}
