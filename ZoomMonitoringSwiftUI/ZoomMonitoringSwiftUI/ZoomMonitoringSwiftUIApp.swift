//
//  ZoomMonitoringSwiftUIApp.swift
//  ZoomMonitoringSwiftUI
//
//  Created by 오영석 on 11/10/23.
//

import SwiftUI

@main
struct ZoomMonitoringSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        await DiscordManager.initialize().runBot()
                    }
                }
        }
    }
}
