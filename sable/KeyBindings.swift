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
    let tab                       : UInt16 = 0x30

    // 20210701 added
    let n                         : UInt16 = 0x2D
    
    var mousePosition: CGPoint!
    var leftMouseDown: CGEvent!
    var leftMouseUp: CGEvent!
    
    let pageLeftBracketKeyDownown: CGEvent!
    let pageLeftBracketKeyUpp: CGEvent!
    let pageRightBracketKeyDownown: CGEvent!
    let pageRightBracketKeyUpp: CGEvent!
    
    let tabLeftKeyDown: CGEvent!   // Ctrl+Shift+Tab
    let tabLeftKeyUp: CGEvent!
    let tabRightKeyDown: CGEvent!  // Ctrl+Tab
    let tabRightKeyUp: CGEvent!

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
    
    // 20210701
    let nKeyDown: CGEvent!
    let nKeyUp: CGEvent!
    let ntKeyUp: CGEvent!
    let ntKeyDown: CGEvent!

    init() {
        pageLeftBracketKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: true)
        pageLeftBracketKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: leftBracket, keyDown: false)
        pageLeftBracketKeyDownown?.flags = CGEventFlags.maskCommand
        pageLeftBracketKeyUpp?.flags = CGEventFlags.maskCommand

        pageRightBracketKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: true)
        pageRightBracketKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: rightBracket, keyDown: false)
        pageRightBracketKeyDownown?.flags = CGEventFlags.maskCommand
        pageRightBracketKeyUpp?.flags = CGEventFlags.maskCommand

        upArrowKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: upArrow, keyDown: true)
        upArrowKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: upArrow, keyDown: false)
        upArrowKeyDownown?.flags = CGEventFlags.maskCommand
        upArrowKeyUpp?.flags = CGEventFlags.maskCommand

        downArrowKeyDownown = CGEvent(keyboardEventSource: src, virtualKey: downArrow, keyDown: true)
        downArrowKeyUpp = CGEvent(keyboardEventSource: src, virtualKey: downArrow, keyDown: false)
        downArrowKeyDownown?.flags = CGEventFlags.maskCommand
        downArrowKeyUpp?.flags = CGEventFlags.maskCommand

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
