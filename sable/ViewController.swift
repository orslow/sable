//
//  ViewController.swift
//  sable
//
//  Created by jueon on 2021/01/06.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    let keySimulator: KeyBindings = KeyBindings()
    override func mouseDown(with event: NSEvent) {
        // (x_movement, y_movement) = (0, 0)
    }

    var current_x: CGFloat = 0.0, current_y: CGFloat = 0.0, x_movement: CGFloat = 0.0, y_movement: CGFloat = 0.0
    var detected = 0b00000000 // starts from 12 o'clock
    
    override func rightMouseDown(with event: NSEvent) {
        let position = event.locationInWindow.self
        current_x=position.x
        current_y=position.y
    }

    override func rightMouseDragged(with event: NSEvent) {
        let position = event.locationInWindow.self
        x_movement += position.x - current_x
        y_movement += position.y - current_y
        current_x = position.x
        current_y = position.y
        gestureRecorder(xd: x_movement, yd: y_movement)
    }
    

    let mrd: CGFloat = 50.0// minimum recognition distance (최소 인식 거리)
    let angle: CGFloat = 0.25
    override func rightMouseUp(with event: NSEvent) {
        print("0b"+String(detected, radix: 2))
        motionInterpreter()
        (x_movement, y_movement) = (0, 0)
        detected=0
    }

    func gestureRecorder(xd: CGFloat, yd: CGFloat) {
        if yd > mrd && abs(xd) / yd < angle { // 12 o'clock
            detected |= 0b10000000
        }
        if xd > mrd && abs(yd) / xd < angle { // 3 o'clock
            detected |= 0b00100000
        }
        if yd < -mrd && abs(xd) / -yd < angle { // 6 o'clock
            detected |= 0b00001000
        }
        if xd < -mrd && abs(yd) / -xd < angle { // 9 o'clock
            detected |= 0b00000010
        }
        if xd > sqrt(mrd) && yd > sqrt(mrd) &&
            yd / xd > angle && xd / yd > angle { // 1:30
            detected |= 0b01000000
        }
        if xd > sqrt(mrd) && yd < -sqrt(mrd) &&
            -yd / xd > angle && xd / -yd > angle { // 4:30
            detected |= 0b00010000
        }
        if xd < -sqrt(mrd) && yd < -sqrt(mrd) &&
            yd / xd > angle && xd / yd > angle { // 7:30
            detected |= 0b00000100
        }
        if xd < -sqrt(mrd) && yd > sqrt(mrd) &&
            yd / -xd > angle && -xd / yd > angle { // 10:30
            detected |= 0b0000001
        }
    }
    
    @IBOutlet weak var leftButton: NSPopUpButton!
    @IBOutlet weak var rightButton: NSPopUpButton!
    @IBOutlet weak var upButton: NSPopUpButton!
    @IBOutlet weak var downButton: NSPopUpButton!
    @IBOutlet weak var uButton: NSPopUpButton!
    @IBOutlet weak var iButton: NSPopUpButton!
    @IBOutlet weak var kButton: NSPopUpButton!
    @IBOutlet weak var jButton: NSPopUpButtonCell!
    @IBOutlet weak var downRightButton: NSPopUpButton!
    @IBOutlet weak var rightUpButton: NSPopUpButton!
    @IBOutlet weak var upLeftButton: NSPopUpButton!
    @IBOutlet weak var leftDownButton: NSPopUpButton!
    @IBOutlet weak var upRightButton: NSPopUpButton!
    @IBOutlet weak var rightDownButton: NSPopUpButton!
    @IBOutlet weak var downLeftButton: NSPopUpButton!
    @IBOutlet weak var leftUpButton: NSPopUpButton!
    
    
    func motionInterpreter() {
        switch detected {
        case 0b00000010:
            makeShortcut(item: leftButton.title)
        case 0b00100000:
            makeShortcut(item: rightButton.title)
        case 0b10000000:
            makeShortcut(item: upButton.title)
        case 0b00001000:
            makeShortcut(item: downButton.title)
        case 0b00000001:
            makeShortcut(item: uButton.title)
        case 0b01000000:
            makeShortcut(item: iButton.title)
        case 0b00010000:
            makeShortcut(item: kButton.title)
        case 0b00000100:
            makeShortcut(item: jButton.title)
        case 0b00011000:
            makeShortcut(item: downRightButton.title)
        case 0b01100000:
            makeShortcut(item: rightUpButton.title)
        case 0b10000001:
            makeShortcut(item: upLeftButton.title)
        case 0b00000110:
            makeShortcut(item: leftDownButton.title)
        case 0b11000000:
            makeShortcut(item: upRightButton.title)
        case 0b00110000:
            makeShortcut(item: rightDownButton.title)
        case 0b00001100:
            makeShortcut(item: downLeftButton.title)
        case 0b00000011:
            makeShortcut(item: leftUpButton.title)
        default:
            break
        }
    }
    
    // No action, Back, Forward, Scroll to top, Scroll to bottom, Close tab, Reopen closed tab, Move to left tab, Move to right tab, Reload
    let action: KeyBindings = KeyBindings()
    func makeShortcut(item: String) {
        switch item {
        case "Back":
            action.back()
        case "Forward":
            action.forward()
        case "Scroll to top":
            action.scrollToTop()
        case "Scroll to bottom":
            action.scrollToBottom()
        case "Close tab":
            action.closeTab()
        case "Reopen closed tab":
            action.reopenClosedTab()
        case "Move to left tab":
            action.leftTab()
        case "Move to right tab":
            action.rightTab()
        case "Reload":
            action.reload()
        default:
            break
        }
    }
}
