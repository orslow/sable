//
//  AppDelegate.swift
//  sable
//
//  Created by jueon on 2021/01/06.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa

var allowedApps: [String] = AppListPreferences.defaultApps

func reloadAllowedApps() {
    allowedApps = AppListPreferences.getAppList()
}

func isAppAllowed(_ appName: String?) -> Bool {
    guard let name = appName else { return false }
    return allowedApps.contains { name.contains($0) }
}

var gestureEventTap: CFMachPort?

func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

    // 타임아웃/사용자 입력으로 탭 비활성화 시 재활성화
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let tap = gestureEventTap {
            CGEvent.tapEnable(tap: tap, enable: true)
        }
        return Unmanaged.passUnretained(event)
    }

    let appName = NSWorkspace.shared.frontmostApplication?.localizedName

    if isAppAllowed(appName) {
        // if [.rightMouseDown , .rightMouseUp].contains(type) {
        if [.rightMouseDown].contains(type) {
            let keyCode = event.getIntegerValueField(.mouseEventClickState)
            if keyCode==2 {
                return Unmanaged.passUnretained(event)
            }
            vc?.globalRightMouseDown(with: event)
        } else if [.rightMouseDragged].contains(type) {
            vc?.globalRightMouseDragged(with: event)
        } else if [.rightMouseUp].contains(type) {
            let keyCode = event.getIntegerValueField(.mouseEventClickState)
            if keyCode==2 {
                return Unmanaged.passUnretained(event)
            }
            vc?.globalRightMouseUp(with: event)
        }
        return nil
    } else {
        return Unmanaged.passUnretained(event)
    }
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    let action = KeyBindings.shared

    let eventMask = (1 << CGEventType.rightMouseDown.rawValue) | (1 << CGEventType.rightMouseUp.rawValue) | (1 << CGEventType.rightMouseDragged.rawValue)

    var accessibilityCheckTimer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        reloadAllowedApps()

        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("sable"))
        }
        constructMenu()

        if AXIsProcessTrusted() {
            startEventTap()
        } else {
            requestAccessibility()
        }
    }

    func requestAccessibility() {
        // 시스템 기본 다이얼로그 표시 + 접근성 목록에 자동 추가
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
        // 타이머로 권한 대기
        waitForAccessibility()
    }

    private var accessibilityRetryCount = 0
    private let maxAccessibilityRetries = 300 // 5분 타임아웃

    func waitForAccessibility() {
        accessibilityRetryCount = 0
        accessibilityCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            if AXIsProcessTrusted() {
                timer.invalidate()
                self.accessibilityCheckTimer = nil
                self.startEventTap()
            } else {
                self.accessibilityRetryCount += 1
                if self.accessibilityRetryCount >= self.maxAccessibilityRetries {
                    timer.invalidate()
                    self.accessibilityCheckTimer = nil
                    let alert = NSAlert()
                    alert.messageText = "Accessibility Permission Timeout"
                    alert.informativeText = "Please grant accessibility permission in System Preferences and restart sable."
                    alert.addButton(withTitle: "Quit")
                    alert.runModal()
                    NSApplication.shared.terminate(nil)
                }
            }
        }
    }

    func startEventTap() {
        guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                               place: .headInsertEventTap,
                                               options: .defaultTap,
                                               eventsOfInterest: CGEventMask(eventMask),
                                               callback: myCGEventCallback,
                                               userInfo: nil)
        else {
            print("failed to create event tap")
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "Failed to create event tap. Please restart sable."
            alert.addButton(withTitle: "Quit")
            alert.runModal()
            NSApplication.shared.terminate(nil)
            return
        }
        gestureEventTap = eventTap
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
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
        NSApplication.shared.activate(ignoringOtherApps: true)
        // ViewController의 윈도우를 직접 참조
        if let window = vc?.view.window {
            window.makeKeyAndOrderFront(self)
            window.level = .floating
        }
    }
    
}

