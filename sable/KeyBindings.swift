//
//  KeyBindings.swift
//  sable
//
//  Created by jueon on 2021/01/08.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa

class KeyBindings {

    static let shared = KeyBindings()

    let src = CGEventSource(stateID: .privateState)
    let loc = CGEventTapLocation.cghidEventTap
    
    let leftBracket               : UInt16 = 0x21
    let rightBracket              : UInt16 = 0x1E
    let upArrow                   : UInt16 = 0x7E
    let downArrow                 : UInt16 = 0x7D
    let w                         : UInt16 = 0x0D
    let t                         : UInt16 = 0x11
    let r                         : UInt16 = 0x0F
    let tab                       : UInt16 = 0x30

    // 20210701 added
    let n                         : UInt16 = 0x2D
    
    var mousePosition: CGPoint?
    var leftMouseDown: CGEvent?
    var leftMouseUp: CGEvent?
    
    let pageLeftBracketKeyDown: CGEvent!
    let pageLeftBracketKeyUp: CGEvent!
    let pageRightBracketKeyDown: CGEvent!
    let pageRightBracketKeyUp: CGEvent!
    
    let tabLeftKeyDown: CGEvent!   // Ctrl+Shift+Tab
    let tabLeftKeyUp: CGEvent!
    let tabRightKeyDown: CGEvent!  // Ctrl+Tab
    let tabRightKeyUp: CGEvent!

    let upArrowKeyDown: CGEvent!
    let upArrowKeyUp: CGEvent!
    let downArrowKeyDown: CGEvent!
    let downArrowKeyUp: CGEvent!
    let wKeyDown: CGEvent!
    let wKeyUp: CGEvent!
    let tKeyDown: CGEvent!
    let tKeyUp: CGEvent!
    let rKeyDown: CGEvent!
    let rKeyUp: CGEvent!
    
    // 20210701
    let nKeyDown: CGEvent!
    let nKeyUp: CGEvent!
    let ntKeyUp: CGEvent!
    let ntKeyDown: CGEvent!

    private init() {
        pageLeftBracketKeyDown = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: true)
        pageLeftBracketKeyUp = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: false)
        pageLeftBracketKeyDown?.flags = CGEventFlags.maskCommand
        pageLeftBracketKeyUp?.flags = CGEventFlags.maskCommand

        pageRightBracketKeyDown = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: true)
        pageRightBracketKeyUp = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: false)
        pageRightBracketKeyDown?.flags = CGEventFlags.maskCommand
        pageRightBracketKeyUp?.flags = CGEventFlags.maskCommand

        upArrowKeyDown = CGEvent(keyboardEventSource: src, virtualKey: upArrow, keyDown: true)
        upArrowKeyUp = CGEvent(keyboardEventSource: src, virtualKey: upArrow, keyDown: false)
        upArrowKeyDown?.flags = CGEventFlags.maskCommand
        upArrowKeyUp?.flags = CGEventFlags.maskCommand

        downArrowKeyDown = CGEvent(keyboardEventSource: src, virtualKey: downArrow, keyDown: true)
        downArrowKeyUp = CGEvent(keyboardEventSource: src, virtualKey: downArrow, keyDown: false)
        downArrowKeyDown?.flags = CGEventFlags.maskCommand
        downArrowKeyUp?.flags = CGEventFlags.maskCommand

        wKeyDown = CGEvent(keyboardEventSource: src, virtualKey: w, keyDown: true)
        wKeyUp = CGEvent(keyboardEventSource: src, virtualKey: w, keyDown: false)
        wKeyDown?.flags = CGEventFlags.maskCommand
        wKeyUp?.flags = CGEventFlags.maskCommand

        tKeyDown = CGEvent(keyboardEventSource: src, virtualKey: t, keyDown: true)
        tKeyUp = CGEvent(keyboardEventSource: src, virtualKey: t, keyDown: false)
        tKeyDown?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]
        tKeyUp?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

        tabLeftKeyDown = CGEvent(keyboardEventSource: src, virtualKey: tab, keyDown: true)
        tabLeftKeyUp = CGEvent(keyboardEventSource: src, virtualKey: tab, keyDown: false)
        tabLeftKeyDown?.flags = [CGEventFlags.maskControl, CGEventFlags.maskShift]
        tabLeftKeyUp?.flags = [CGEventFlags.maskControl, CGEventFlags.maskShift]

        tabRightKeyDown = CGEvent(keyboardEventSource: src, virtualKey: tab, keyDown: true)
        tabRightKeyUp = CGEvent(keyboardEventSource: src, virtualKey: tab, keyDown: false)
        tabRightKeyDown?.flags = CGEventFlags.maskControl
        tabRightKeyUp?.flags = CGEventFlags.maskControl

        rKeyDown = CGEvent(keyboardEventSource: src, virtualKey: r, keyDown: true)
        rKeyUp = CGEvent(keyboardEventSource: src, virtualKey: r, keyDown: false)
        rKeyDown?.flags = CGEventFlags.maskCommand
        rKeyUp?.flags = CGEventFlags.maskCommand

        // new window
        nKeyDown = CGEvent(keyboardEventSource: src, virtualKey: n, keyDown: true)
        nKeyUp = CGEvent(keyboardEventSource: src, virtualKey: n, keyDown: false)
        nKeyDown?.flags = CGEventFlags.maskCommand
        nKeyUp?.flags = CGEventFlags.maskCommand

        // new tab
        ntKeyDown = CGEvent(keyboardEventSource: src, virtualKey: t, keyDown: true)
        ntKeyUp = CGEvent(keyboardEventSource: src, virtualKey: t, keyDown: false)
        ntKeyDown?.flags = CGEventFlags.maskCommand
        ntKeyUp?.flags = CGEventFlags.maskCommand

    }

    // back, forward, scrollToTop, scrollToBottom, closeTab, reopenClosedTab, reload, leftTab, rightTab, newWindow, newTab
    
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
        pageLeftBracketKeyDown?.post(tap: loc)
        pageLeftBracketKeyUp?.post(tap: loc)
    }
    
    func forward() {
        pageRightBracketKeyDown?.post(tap: loc)
        pageRightBracketKeyUp?.post(tap: loc)
    }
    
    func scrollToTop() {
        upArrowKeyDown?.post(tap: loc)
        upArrowKeyUp?.post(tap: loc)
    }
    
    func scrollToBottom() {
        downArrowKeyDown?.post(tap: loc)
        downArrowKeyUp?.post(tap: loc)
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
        tabLeftKeyDown?.post(tap: loc)
        tabLeftKeyUp?.post(tap: loc)
    }

    func rightTab() {
        tabRightKeyDown?.post(tap: loc)
        tabRightKeyUp?.post(tap: loc)
    }
    
    func reload() {
        rKeyDown?.post(tap: loc)
        rKeyUp?.post(tap: loc)
    }
    
    // 20210701
    func newWindow() {
        nKeyDown?.post(tap: loc)
        nKeyUp?.post(tap: loc)
    }
    
    func newTab() {
        ntKeyDown?.post(tap: loc)
        ntKeyUp?.post(tap: loc)
    }

}
