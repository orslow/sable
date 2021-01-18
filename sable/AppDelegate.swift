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
    
    if (appName?.contains("Chrome"))! || (appName?.contains("Safari"))! {
        // if [.rightMouseDown , .rightMouseUp].contains(type) {
        if [.rightMouseDown].contains(type) {
            let keyCode = event.getIntegerValueField(.mouseEventClickState)
            if keyCode==2 {
                return Unmanaged.passRetained(event)
            }
            vc?.globalRightMouseDown2(with: event)
        } else if [.rightMouseDragged].contains(type) {
            vc?.globalRightMouseDragged2(with: event)
        } else if [.rightMouseUp].contains(type) {
            let keyCode = event.getIntegerValueField(.mouseEventClickState)
            if keyCode==2 {
                return Unmanaged.passRetained(event)
            }
            vc?.globalRightMouseUp()
        }
        return nil
        // return Unmanaged.passRetained(event)
    } else {
        return Unmanaged.passRetained(event)
    }

    /*
    // if [.rightMouseDown , .rightMouseUp].contains(type) {
    if [.rightMouseDown].contains(type) {
        let keyCode = event.getIntegerValueField(.mouseEventClickState)
        print("With", keyCode)
        if keyCode==2 {
            event.setIntegerValueField(.mouseEventClickState, value: 1)
            return Unmanaged.passRetained(event)
        }
        vc?.globalRightMouseDown2(with: event)
    } else if [.rightMouseDragged].contains(type) {
        vc?.globalRightMouseDragged2(with: event)
    } else {
        vc?.globalRightMouseUp()
    }
    return nil
    // return Unmanaged.passRetained(event)
    */
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
                                               userInfo: nil) else {
                                                print("failed to create event tap")
                                                exit(1)
        }
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText = "App icon clicked"
        let quoteAuthor = "Alarm"
        
        print("\(quoteText) - \(quoteAuthor)")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        // menu.addItem(NSMenuItem(title: "Print", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
        
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.getPreferences(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func getPreferences(_ sender: Any?) {
        NSApplication.shared.orderedWindows.forEach({ (window) in
            NSApplication.shared.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(self)
            window.makeKey()
            /*
            if let mainWindow = window as? MainWindow {
                print("HERE?")
                NSApplication.shared.activate(ignoringOtherApps: true)
                mainWindow.makeKeyAndOrderFront(self)
                mainWindow.makeKey()
            }
            */
        })

    }
    
}

