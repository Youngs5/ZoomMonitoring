//
//  ContentView.swift
//  ZoomMonitoringSwiftUI
//
//  Created by 오영석 on 11/10/23.
//

import SwiftUI
import AppKit
import Vision

struct ContentView: View {
    @ObservedObject private var zoomStore = ZoomStore()
    
    var body: some View {
        VStack {
            HStack {
                Button("Start") {
                    print("Start button tapped")
                    zoomStore.startTimer()
                }
                .padding()
                
                Button("End") {
                    print("End button tapped")
                    zoomStore.stopTimer()
                }
                Button("Capture Screen") {
                    zoomStore.captureScreen()
                }
                .padding()
            }
            
            Text("\(zoomStore.currentTime)")
            
            if let image = zoomStore.image {
                ZStack {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    ForEach(zoomStore.faceObservations, id: \.self) { observation in
                        Rectangle()
                            .stroke(Color.green, lineWidth: 4)
                            .frame(width: observation.boundingBox.width * image.size.width, height: observation.boundingBox.height * image.size.height)
                            .offset(x: observation.boundingBox.minX * image.size.width - image.size.width / 2, y: observation.boundingBox.minY * image.size.height - image.size.height / 2)
                    }
                }
            }
            
            if zoomStore.faceObservations.isEmpty {
                Text("감지된 얼굴 없음")
            } else {
                Text("감지된 얼굴 수: \(zoomStore.faceObservations.count)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
