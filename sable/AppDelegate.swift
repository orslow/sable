//
//  AppDelegate.swift
//  sable
//
//  Created by jueon on 2021/01/06.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa

func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

    let appName = NSWorkspace.shared.frontmostApplication?.localizedName
    
    if (appName?.contains("Chrome"))! ||
        (appName?.contains("Safari"))! ||
        (appName?.contains("Brave"))! ||
        (appName?.contains("Firefox"))! {
        // if [.rightMouseDown , .rightMouseUp].contains(type) {
        if [.rightMouseDown].contains(type) {
            let keyCode = event.getIntegerValueField(.mouseEventClickState)
            if keyCode==2 {
                return Unmanaged.passRetained(event)
            }
            vc?.globalRightMouseDown(with: event)
        } else if [.rightMouseDragged].contains(type) {
            vc?.globalRightMouseDragged(with: event)
        } else if [.rightMouseUp].contains(type) {
            let keyCode = event.getIntegerValueField(.mouseEventClickState)
            if keyCode==2 {
                return Unmanaged.passRetained(event)
            }
            vc?.globalRightMouseUp(with: event)
        }
        return nil
    } else {
        return Unmanaged.passRetained(event)
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    let action: KeyBindings = KeyBindings()

    let eventMask = (1 << CGEventType.rightMouseDown.rawValue) | (1 << CGEventType.rightMouseUp.rawValue) | (1 << CGEventType.rightMouseDragged.rawValue)

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("sable"))
            // button.action = #selector(printQuote(_:)) // with no menu
        }
        constructMenu()
        
        guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                               place: .headInsertEventTap,
                                               options: .defaultTap,
                                               eventsOfInterest: CGEventMask(eventMask),
                                               callback: myCGEventCallback,
                                               userInfo: nil)
            else {
                print("failed to create event tap")
                let alert = NSAlert.init()
                alert.messageText = ""
                alert.informativeText = "Grant access to sable in System Preferences and reopen application."
                alert.addButton(withTitle: "OK")
                alert.runModal()
                exit(1);
        }
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.getPreferences(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func getPreferences(_ sender: Any?) {
        let prefWindow = NSApplication.shared.windows.last
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        prefWindow?.makeKeyAndOrderFront(self)
        prefWindow?.makeKey()
    }
    
}

