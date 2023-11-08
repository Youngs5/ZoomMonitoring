//
//  AnalyzeScreenViewModel.swift
//  Monitoring
//
//  Created by 오영석 on 11/1/23.
//

import Foundation
import AppKit

class AnalyzeScreenViewModel {
    let yoloService: YoloService
    var onPeopleDetected: ((Int) -> Void)?

    var detectedPeopleCount: Int = 0 {
        didSet {
            onPeopleDetected?(detectedPeopleCount)
        }
    }

    init(yoloService: YoloService) {
        self.yoloService = yoloService
    }

    func analyzeScreen(image: NSImage) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        yoloService.detectPeople(image: cgImage) { [weak self] isPersonDetected in
            if (isPersonDetected != 0) {
                self?.detectedPeopleCount += 1
                print("감지 시도 횟수: \(self?.detectedPeopleCount ?? 0)")
            }
        }
    }
}
