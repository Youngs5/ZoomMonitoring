//
//  ContentView.swift
//  ZoomMonitoringSwiftUI
//
//  Created by 오영석 on 11/10/23.
//

//
//  ContentView.swift
//  Facelook
//
//  Created by Jongwook Park on 11/9/23.
//

import SwiftUI
import AppKit
import Vision

struct ContentView: View {
    @State private var image: NSImage?
    @State private var faceObservations: [VNFaceObservation] = []
    
    var body: some View {
        VStack {
            Button("Capture Screen") {
                captureScreen()
            }
            if let image = image {
                ZStack {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    ForEach(faceObservations, id: \.self) { observation in
                        Rectangle()
                            .stroke(Color.green, lineWidth: 4)
                            .frame(width: observation.boundingBox.width * image.size.width, height: observation.boundingBox.height * image.size.height)
                            .offset(x: observation.boundingBox.minX * image.size.width - image.size.width / 2, y: observation.boundingBox.minY * image.size.height - image.size.height / 2)
                    }
                }
            }
            
            
            if faceObservations.isEmpty {
                Text("Hello")
            } else {
                Text("Number of faces: \(faceObservations.count)")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.black.opacity(0.7))
//                    .cornerRadius(10)
//                    .offset(y: -image.size.height / 2 + 50)
            }
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

#Preview {
    ContentView()
}
