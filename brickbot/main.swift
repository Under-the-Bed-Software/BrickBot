//
//  main.swift
//  brickbot
//
//  Created by skg on 7/24/21.
//

import Foundation
import IRC
import Dispatch

print("Hello, World!")

let sslOptions = IRCClientSecurityOptions(useSecure: true, vertificationMode: .strict)

let bot = BrickBot(options: BrickBot.Options(port: 6697, host: "irc.snoonet.org", securityOptions: sslOptions, nickname: IRCNickName("brickbot2")!, userInfo: IRCUserInfo(username: "bricks", usermask: IRCUserMode(), realname: "bricks")))
bot.connect()
bot.loadCommands()

dispatchMain()

