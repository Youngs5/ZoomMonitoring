//
//  CaptureScreenViewController.swift
//  Monitoring
//
//  Created by 오영석 on 11/1/23.
//

import Cocoa

class CaptureScreenViewController: NSViewController {
    override func loadView() {
        let view = NSView(frame: NSScreen.main!.frame)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor
        self.view = view
    }
}
