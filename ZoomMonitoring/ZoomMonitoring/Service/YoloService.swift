//
//  File.swift
//  Monitoring
//
//  Created by 오영석 on 11/1/23.
//

import Foundation
import CoreML
import Vision

class YoloService {
    private var isDetectedImage: Bool = false
    private var objectDetectionRequest: VNCoreMLRequest?
    var detectedLabelsCount: Int = 0
    
    init() {
        loadYOLOv3TinyModel()
    }
    
    private func loadYOLOv3TinyModel() {
        let configuration = MLModelConfiguration()
        guard let yoloTinyModel = try? VNCoreMLModel(for: YOLOv3Tiny(configuration: configuration).model) else {
            fatalError("Failed to load YOLOv3 Tiny model.")
        }

        objectDetectionRequest = VNCoreMLRequest(model: yoloTinyModel, completionHandler: { [weak self] request, error in
            let detectedLabelsCount = self?.handleObjectDetectionResults(request: request, error: error) ?? 0
            print("Detected Labels Count: \(detectedLabelsCount)")
            if detectedLabelsCount > 0 {
                self?.isDetectedImage = true
            } else {
                self?.isDetectedImage = false
            }
        })
    }

    private func handleObjectDetectionResults(request: VNRequest, error: Error?) -> Int {
        guard let results = request.results as? [VNRecognizedObjectObservation] else { return 0 }

        var detectedLabels = [String]()
        
        for result in results {
            if let label = result.labels.first {
                if label.identifier == "person" {
                    if label.confidence * 100 >= 90 {
                        detectedLabels.append(label.identifier)
                    }
                }
            }
        }
        detectedLabelsCount = detectedLabels.count
        return detectedLabels.count
    }

    func detectObjects(image: CGImage, completion: @escaping (Int) -> ()) {
        guard let objectDetectionRequest = objectDetectionRequest else { return }

        let request = VNCoreMLRequest(model: objectDetectionRequest.model) { request, error in
            let detectedLabels = self.handleObjectDetectionResults(request: request, error: error)
            completion(detectedLabels)
        }

        let handler = VNImageRequestHandler(cgImage: image, options: [:])

        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform object detection: \(error)")
            completion(0)
        }
    }
    
    func detectPeople(image: CGImage, completion: @escaping (Int) -> Void) {
        guard let objectDetectionRequest = objectDetectionRequest else { return }

        let request = VNCoreMLRequest(model: objectDetectionRequest.model) { [weak self] request, error in
            let detectedLabelsCount = self?.handleObjectDetectionResults(request: request, error: error) ?? 0
            completion(detectedLabelsCount)
        }

        let handler = VNImageRequestHandler(cgImage: image, options: [:])

        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform object detection: \(error)")
            completion(0)
        }
    }
}
