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
    
    var mousePosition: CGPoint!
    var leftMouseDown: CGEvent!
    var leftMouseUp: CGEvent!
    
    let pageLeftBracketKeyDownown: CGEvent!
    let pageLeftBracketKeyUpp: CGEvent!
    let pageRightBracketKeyDownown: CGEvent!
    let pageRightBracketKeyUpp: CGEvent!
    
    let tabLeftBracketKeyDownown: CGEvent!
    let tabLeftBracketKeyUpp: CGEvent!
    let tabRightBracketKeyDownown: CGEvent!
    let tabRightBracketKeyUpp: CGEvent!

    let upArrowKeyDownown: CGEvent!
    let upArrowKeyUpp: CGEvent!
    let downArrowKeyDownown: CGEvent!
    let downArrowKeyUpp: CGEvent!
    let wKeyDown: CGEvent!
    let wKeyUp: CGEvent!
    let tKeyDown: CGEvent!
    let tKeyUp: CGEvent!
    let rKeyDown: CGEvent!
    let rKeyUp: CGEvent!

    init() {
        pageLeftBracketKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: true)
        pageLeftBracketKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: false)
        pageLeftBracketKeyDownown?.flags = CGEventFlags.maskCommand // with cmd+
        
        pageRightBracketKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: true)
        pageRightBracketKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: false)
        pageRightBracketKeyDownown?.flags = CGEventFlags.maskCommand // with cmd+
        
        upArrowKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: upArrow, keyDown: true)
        upArrowKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: upArrow, keyDown: false)
        upArrowKeyDownown?.flags = CGEventFlags.maskCommand // with cmd+
        
        downArrowKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: downArrow, keyDown: true)
        downArrowKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: downArrow, keyDown: false)
        downArrowKeyDownown?.flags = CGEventFlags.maskCommand // with cmd+
        
        wKeyDown = CGEvent(keyboardEventSource: src, virtualKey: w, keyDown: true)
        wKeyUp = CGEvent(keyboardEventSource: src, virtualKey: w, keyDown: false)
        wKeyDown?.flags = CGEventFlags.maskCommand // with cmd+
        
        tKeyDown = CGEvent(keyboardEventSource: src, virtualKey: t, keyDown: true)
        tKeyUp = CGEvent(keyboardEventSource: src, virtualKey: t, keyDown: false)
        tKeyDown?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift ] // with cmd+shift+
        
        tabLeftBracketKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: true)
        tabLeftBracketKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: false)
        tabLeftBracketKeyDownown?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift ] // with cmd+shift+
        
        tabRightBracketKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: true)
        tabRightBracketKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: false)
        tabRightBracketKeyDownown?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift ] // with cmd+shift+
        
        rKeyDown = CGEvent(keyboardEventSource: src, virtualKey: r, keyDown: true)
        rKeyUp = CGEvent(keyboardEventSource: src, virtualKey: r, keyDown: false)
        rKeyDown?.flags = CGEventFlags.maskCommand // with cmd+
    }

    // back, forward, scrollToTop, scrollToBottom, closeTab, reopenClosedTab, reload, leftTab, rightTab
    
    func rightClick(pos: CGPoint) {
        leftMouseDown = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown,
                                mouseCursorPosition: pos, mouseButton: .left)
        leftMouseUp = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp,
                                mouseCursorPosition: pos, mouseButton: .left)
        
        leftMouseDown?.flags = CGEventFlags.maskControl
        leftMouseUp?.flags = CGEventFlags.maskControl
        
        leftMouseDown?.post(tap: loc)
        leftMouseUp?.post(tap: loc)
    }

    func back() {
        pageLeftBracketKeyDownown?.post(tap: loc)
        pageLeftBracketKeyUpp?.post(tap: loc)
    }
    
    func forward() {
        pageRightBracketKeyDownown?.post(tap: loc)
        pageRightBracketKeyUpp?.post(tap: loc)
    }
    
    func scrollToTop() {
        upArrowKeyDownown?.post(tap: loc)
        upArrowKeyUpp?.post(tap: loc)
    }
    
    func scrollToBottom() {
        downArrowKeyDownown?.post(tap: loc)
        downArrowKeyUpp?.post(tap: loc)
    }

    func closeTab() {
        wKeyDown?.post(tap: loc)
        wKeyUp?.post(tap: loc)
    }

    func reopenClosedTab() {
        tKeyDown?.post(tap: loc)
        tKeyUp?.post(tap: loc)
    }
    
    func leftTab() {
        tabLeftBracketKeyDownown?.post(tap: loc)
        tabLeftBracketKeyUpp?.post(tap: loc)
    }
    
    func rightTab() {
        tabRightBracketKeyDownown?.post(tap: loc)
        tabRightBracketKeyUpp?.post(tap: loc)
    }
    
    func reload() {
        rKeyDown?.post(tap: loc)
        rKeyUp?.post(tap: loc)
    }
}
