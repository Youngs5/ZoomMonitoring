//
//  Store.swift
//  ZoomMonitoringSwiftUI
//
//  Created by 오영석 on 11/10/23.
//

import Foundation
import AppKit
import Vision

class ZoomStore: ObservableObject {
    @Published var image: NSImage?
    @Published var faceObservations: [VNFaceObservation] = []
    @Published var currentTime: String = "00:00"
    
    private var timer: Timer?
    private var startTime: Date?
    
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.updateCurrentTime()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        currentTime = "00:00"
    }
    
    func updateCurrentTime() {
        guard let startTime = startTime else { return }
        
        let elapsedTime = Int(Date().timeIntervalSince(startTime))
        let minutes = (elapsedTime / 60) % 60
        let seconds = elapsedTime % 60
        
        let formattedTime = String(format: "%02d:%02d", minutes, seconds)
        
        DispatchQueue.main.async {
            self.currentTime = formattedTime
        }
    }
    
    func captureScreen() {
        let displayID = CGMainDisplayID()
        guard let imageRef = CGDisplayCreateImage(displayID) else { return }
        image = NSImage(cgImage: imageRef, size: NSSize(width: imageRef.width, height: imageRef.height))
        detectFaces()
    }
    
    func detectFaces() {
        guard let image = image else { return }
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        
        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Face detection error: \(error.localizedDescription)")
            }
            
            guard let results = request.results as? [VNFaceObservation] else { return }
            
            DispatchQueue.main.async {
                self.faceObservations = results
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Face detection request error: \(error.localizedDescription)")
        }
    }
}
