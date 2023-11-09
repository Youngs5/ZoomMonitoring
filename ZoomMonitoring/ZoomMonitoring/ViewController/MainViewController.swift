import Cocoa

class MainViewController: NSViewController {
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
        
        addViews()
        makeConstraints()
        configCapture()
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
    
    private func makeConstraints() {
        view.wantsLayer = true
        view.layer?.zPosition = 0
        
        startButton.target = self
        endButton.target = self
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            endButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            endButton.leadingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: 10),
            
            timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            timerLabel.leadingAnchor.constraint(equalTo: endButton.trailingAnchor, constant: 10)
        ])
    }
    
    private func configCapture() {
        captureScreenViewModel = CaptureScreenViewModel(yoloService: YoloService(), analyzeScreenViewModel: AnalyzeScreenViewModel(yoloService: YoloService()))
        captureScreenViewModel.onPersonDetected = { isPersonDetected in
            print("사람 감지 여부: \(isPersonDetected)")
        }
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
            window.backgroundColor = NSColor.clear
        }
    }
    
    @objc func endButtonClicked() {
        timer?.invalidate()
        timer = nil
        
        timerLabel.stringValue = "00:00"
        
        captureScreenViewModel.stopCapture()
        
        if let window = view.window {
            window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
    private func updateTimerLabel() {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        timerLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
    }
}
