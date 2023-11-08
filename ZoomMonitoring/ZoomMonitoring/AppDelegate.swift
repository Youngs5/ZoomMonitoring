//
//  AppDelegate.swift
//  Monitoring
//
//  Created by 오영석 on 11/2/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentViewController = MainViewController()
        window = NSWindow(contentViewController: contentViewController)
        window.title = "Monitoring System"
        window.setContentSize(NSSize(width: 800, height: 600))
        window.center()
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
}
