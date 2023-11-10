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
    
    func captureScreen() {
        let displayID = CGMainDisplayID()
        guard let imageRef = CGDisplayCreateImage(displayID) else { return }
        image = NSImage(cgImage: imageRef, size: NSSize(width: imageRef.width, height: imageRef.height))
        detectFaces()
    }
    
    func detectFaces() {
        guard let image = image else { return }
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        let request = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                print("Face detection error: \(error.localizedDescription)")
            }
            guard let results = request.results as? [VNFaceObservation] else { return }
            self.faceObservations = results
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Face detection request error: \(error.localizedDescription)")
        }
    }
}
