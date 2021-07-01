//
//  ViewController.swift
//  sable
//
//  Created by jueon on 2021/01/06.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa

weak var vc = ViewController()

class ViewController: NSViewController {
    
    @IBOutlet var MainView: NSView!
    
    override func viewDidDisappear() {
        updateGlobalShortcutOnJson()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        vc = self

        if Storage.fileExists("globalKeybind.json", in: .documents) {
            let globalKeybinds = Storage.retrieve("globalKeybind.json", from: .documents, as: KeybindPreferences.self)
            updateKeybindButtonFromJson(globalKeybinds)
        }
    }
    
    // update keybinding when view disappear
    func updateGlobalShortcutOnJson() {
        let newGlobalKeybind = KeybindPreferences.init(
            left: leftButton.indexOfSelectedItem,
            right: rightButton.indexOfSelectedItem,
            up: upButton.indexOfSelectedItem,
            down: downButton.indexOfSelectedItem,
            u: uButton.indexOfSelectedItem,
            i: iButton.indexOfSelectedItem,
            k: kButton.indexOfSelectedItem,
            j: jButton.indexOfSelectedItem,
            down_right: downRightButton.indexOfSelectedItem,
            right_up: rightUpButton.indexOfSelectedItem,
            up_left: upLeftButton.indexOfSelectedItem,
            left_down: leftDownButton.indexOfSelectedItem,
            up_right: upRightButton.indexOfSelectedItem,
            right_down: rightDownButton.indexOfSelectedItem,
            down_left: downLeftButton.indexOfSelectedItem,
            left_up: leftUpButton.indexOfSelectedItem,
            characters: "nothing"
        )

        Storage.store(newGlobalKeybind, to: .documents, as: "globalKeybind.json")
    }

    // Set the shortcut button to show the keys to press
    func updateKeybindButtonFromJson(_ KeybindPreference : KeybindPreferences) {
        leftButton.selectItem(at: KeybindPreference.left)
        rightButton.selectItem(at: KeybindPreference.right)
        upButton.selectItem(at: KeybindPreference.up)
        downButton.selectItem(at: KeybindPreference.down)
        uButton.selectItem(at: KeybindPreference.u)
        iButton.selectItem(at: KeybindPreference.i)
        kButton.selectItem(at: KeybindPreference.k)
        jButton.selectItem(at: KeybindPreference.j)
        downRightButton.selectItem(at: KeybindPreference.down_right)
        rightUpButton.selectItem(at: KeybindPreference.right_up)
        upLeftButton.selectItem(at: KeybindPreference.up_left)
        leftDownButton.selectItem(at: KeybindPreference.left_down)
        upRightButton.selectItem(at: KeybindPreference.up_right)
        rightDownButton.selectItem(at: KeybindPreference.right_down)
        downLeftButton.selectItem(at: KeybindPreference.down_left)
        leftUpButton.selectItem(at: KeybindPreference.left_up)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    let keySimulator: KeyBindings = KeyBindings()

    var current_x: CGFloat = 0.0, current_y: CGFloat = 0.0, x_movement: CGFloat = 0.0, y_movement: CGFloat = 0.0
    var detected = 0b00000000 // starts from 12 o'clock
    
    func globalRightMouseDown(with event: CGEvent) {
        current_x = event.location.x
        current_y = event.location.y
        // print(current_x, current_y)
    }

    func globalRightMouseDragged(with event: CGEvent) {
        let x = event.location.x
        let y = event.location.y

        x_movement += x - current_x
        y_movement -= y - current_y // reverse on CGEvent
        current_x = x
        current_y = y
        gestureRecorder(xd: x_movement, yd: y_movement)
    }
    
    func globalRightMouseUp(with event: CGEvent) {
        print("0b"+String(detected, radix: 2))
        
        // just right click without any gesture
        if detected==0 {
            action.rightClick(pos: event.location)
            return
        }
        
        motionInterpreter()
        (x_movement, y_movement) = (0, 0)
        detected=0
        
        /*
        let seconds = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            EscKeyDown?.post(tap: loc)
            EscKeyUp?.post(tap: loc)
        }
        */
    }

    let mrd: CGFloat = 50.0 // minimum recognition distance (최소 인식 거리)
    let angle: CGFloat = 0.25 // 대각선 인식 기준 각도
    
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
    @IBOutlet weak var jButton: NSPopUpButton!
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
        case "Open a new window":
            action.newWindow()
        case "Open a new tab":
            action.newTab()
        default:
            break
        }
    }
}
