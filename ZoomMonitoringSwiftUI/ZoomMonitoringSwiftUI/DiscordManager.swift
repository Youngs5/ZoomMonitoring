//
//  DiscordManager.swift
//  ZoomMonitoringSwiftUI
//
//  Created by 오영석 on 11/16/23.
//

import Foundation
import Discord

class DiscordManager {
    static let shared = DiscordManager()
    private let bot: Bot

    private init() {
        // 봇 초기화
        self.bot = Bot(token: "MTE3NDQwNDA5NTU4MzQ2OTYwOA.GuwQ5J.bdQ6jvg45T0gawSLgUtqJ6b8ogq1IVgHQYiTKM", intents: Intents.default)
        print("Bot initialized")
    }

    static func initialize() async -> DiscordManager {
        let manager = DiscordManager.shared
        await manager.setupCommands()
        return manager
    }

    private func setupCommands() async {
        // Add your slash commands and user commands here
        bot.addSlashCommand(
            name: "example",
            description: "Example command",
            guildId: nil,
            onInteraction: { interaction in
                try! await interaction.respondWithMessage("This is an example", ephemeral: true)
            }
        )

        bot.addUserCommand(
            name: "Who is",
            guildId: 1234567890123456789,
            onInteraction: { interaction in
                try! await interaction.respondWithMessage("...")
            }
        )
        
        // Sync application commands (Only needs to be done once)
        try! await bot.syncApplicationCommands()
    }

    func runBot() {
        bot.run()
    }
}
