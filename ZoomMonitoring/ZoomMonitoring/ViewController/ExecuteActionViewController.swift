//
//  ExecuteActionViewController.swift
//  Monitoring
//
//  Created by 오영석 on 11/1/23.
//

import Cocoa

class ExecuteActionViewController: NSViewController {
    override func loadView() {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.blue.cgColor
        self.view = view
    }
}
