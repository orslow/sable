//
//  GlobalEventMonitor.swift
//  sable
//
//  Created by jueon on 2021/01/11.
//  Copyright © 2021 jueon. All rights reserved.
//

import Foundation
import Cocoa

public class GlobalEventMonitor {
    
    private var monitor: AnyObject?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> ()
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        // monitor = NSEvent.addGlobalMonitorForEventsMatchingMask(mask, handler: handler)
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject?
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
