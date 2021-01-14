//
//  AppDelegate.swift
//  sable
//
//  Created by jueon on 2021/01/06.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    let action: KeyBindings = KeyBindings()

    var upEventHandler: GlobalEventMonitor?
    var downEventHandler: GlobalEventMonitor?
    var dragEventHandler: GlobalEventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("sable"))
            // button.action = #selector(printQuote(_:)) // with no menu
        }
        constructMenu()
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

