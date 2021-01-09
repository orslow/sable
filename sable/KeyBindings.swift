//
//  KeyBindings.swift
//  sable
//
//  Created by jueon on 2021/01/08.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa

class KeyBindings {

    let src = CGEventSource(stateID: .privateState)
    let loc = CGEventTapLocation.cghidEventTap
    
    let leftBracket               : UInt16 = 0x21
    let rightBracket              : UInt16 = 0x1E
    let upArrow                   : UInt16 = 0x7E
    let downArrow                 : UInt16 = 0x7D
    let w                         : UInt16 = 0x0D
    let t                         : UInt16 = 0x11
    let r                         : UInt16 = 0x0F

    // back, forward, scrollToTop, scrollToBottom, closeTab, reopenClosedTab, reload, leftTab, rightTab

    func back() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: false)
        
        keyd?.flags = CGEventFlags.maskCommand // with cmd+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }
    
    func forward() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: false)
        
        keyd?.flags = CGEventFlags.maskCommand // with cmd+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }
    
    func scrollToTop() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: upArrow, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: upArrow, keyDown: false)
        
        keyd?.flags = CGEventFlags.maskCommand // with cmd+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }
    
    func scrollToBottom() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: downArrow, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: downArrow, keyDown: false)
        
        keyd?.flags = CGEventFlags.maskCommand // with cmd+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }

    func closeTab() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: w, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: w, keyDown: false)
        
        keyd?.flags = CGEventFlags.maskCommand // with cmd+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }

    func reopenClosedTab() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: t, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: t, keyDown: false)
        
        keyd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift ]// with cmd+shift+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }
    
    func leftTab() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: false)
        
        keyd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift ] // with cmd+shift+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }
    
    func rightTab() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: false)
        
        keyd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift ] // with cmd+shift+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }
    
    func reload() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: r, keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: r, keyDown: false)
        
        keyd?.flags = CGEventFlags.maskCommand // with cmd+
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }
    
    /*
    func screenShot() {
        let frd = CGEvent(keyboardEventSource: src, virtualKey: 0x15, keyDown: true)
        let fru = CGEvent(keyboardEventSource: src, virtualKey: 0x15, keyDown: false)
        
        frd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]
        // var flagRaw : UInt64 = 0
        // flagRaw = CGEventFlags.maskCommand.rawValue
        // frd?.flags = CGEventFlags(rawValue: CGEventFlags.maskShift.rawValue | flagRaw)
        
        frd?.post(tap: loc)
        fru?.post(tap: loc)
    }
    
    func printTest() {
        let keyd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(upArrow), keyDown: true)
        let keyu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(upArrow), keyDown: false)
        
        keyd?.post(tap: loc)
        keyu?.post(tap: loc)
    }
     */
}
