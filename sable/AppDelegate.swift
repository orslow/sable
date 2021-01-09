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

    let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)

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
        
        menu.addItem(NSMenuItem(title: "Print", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
}

