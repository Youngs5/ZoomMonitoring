//
//  AnalyzeScreenViewController.swift
//  Monitoring
//
//  Created by 오영석 on 11/1/23.
//

import Cocoa

class AnalyzeScreenViewController: NSViewController {
    override func loadView() {
        let view = NSView(frame: NSScreen.main!.frame)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.green.cgColor
        self.view = view
    }
}
