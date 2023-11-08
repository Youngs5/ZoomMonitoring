//
//  MainViewController.swift
//  Monitoring
//
//  Created by 오영석 on 11/1/23.
//

import Cocoa

class MainViewController: NSViewController {
    var captureScreenViewController: CaptureScreenViewController?
    var analyzeScreenViewController: AnalyzeScreenViewController?
    var executeActionViewController: ExecuteActionViewController?
    var captureScreenViewModel: CaptureScreenViewModel!
    
    private let startButton: NSButton = {
        let button = NSButton(title: "Start", target: nil, action: #selector(startButtonClicked))
        button.bezelStyle = .rounded
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let endButton: NSButton = {
        let button = NSButton(title: "End", target: nil, action: #selector(endButtonClicked))
        button.bezelStyle = .rounded
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timerLabel: NSTextField = {
        let label = NSTextField()
        label.stringValue = "00:00"
        label.isEditable = false
        label.isBordered = false
        label.isBezeled = false
        label.alignment = .center
        label.font = NSFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var elapsedTime: TimeInterval = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureScreenViewModel = CaptureScreenViewModel(yoloService: YoloService(), analyzeScreenViewModel: AnalyzeScreenViewModel(yoloService: YoloService()))
        captureScreenViewModel.onPersonDetected = { isPersonDetected in
            print("사람 감지 여부: \(isPersonDetected)")
        }
        addViews()
        setupUI()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if let window = view.window {
            window.styleMask.insert(.resizable)
            window.styleMask.insert(.fullSizeContentView)
            
            window.isOpaque = false
            window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
    }
    
    private func addViews() {
        view.addSubview(startButton)
        view.addSubview(endButton)
        view.addSubview(timerLabel)
    }
    
    private func setupUI() {
        captureScreenViewController?.view.frame = view.bounds
        analyzeScreenViewController?.view.frame = view.bounds
        executeActionViewController?.view.frame = view.bounds
        
        if let captureView = captureScreenViewController?.view {
            captureView.frame = view.bounds
        }
        
        if let analyzeView = analyzeScreenViewController?.view {
            analyzeView.frame = view.bounds
        }
        
        if let executeView = executeActionViewController?.view {
            executeView.frame = view.bounds
        }
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            endButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            endButton.leadingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: 10)
        ])
        
        view.wantsLayer = true
        view.layer?.zPosition = 0
        
        startButton.target = self
        endButton.target = self
    }
    
    @objc func startButtonClicked() {
        timer?.invalidate()
        
        elapsedTime = 0
        updateTimerLabel()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
            self?.updateTimerLabel()
        }
        
        captureScreenViewModel.startCapture()
        
        if let window = view.window {
//            window.isOpaque = false
            window.backgroundColor = NSColor.clear
//            window.ignoresMouseEvents = false
        }
    }
    
    @objc func endButtonClicked() {
        timer?.invalidate()
        timer = nil
        
        timerLabel.stringValue = "00:00"
        
        captureScreenViewModel.stopCapture()
        
        if let window = view.window {
//            window.isOpaque = false
            window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//            window.ignoresMouseEvents = true
        }
    }
    
    private func updateTimerLabel() {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        timerLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
    }
}
