//
//  main.swift
//  BrickServ3
//
//  Created by skg on 7/4/21.
//

import Foundation
import Dispatch
import IRC

let sslOptions = IRCClientSecurityOptions(useSecure: true, vertificationMode: .noChecks)

let bot = BrickServBot(options: BrickServBot.Options(port: 6697, host: "192.168.1.202", securityOptions: sslOptions, nickname: IRCNickName("brickbot")!, userInfo: IRCUserInfo(username: "bricks", usermask: IRCUserMode(), realname: "bricks")))
bot.connect()

let queue = DispatchQueue(label: "REPL")

queue.async {
    var connected = true
    bot.ircClient.sendMessage(.init(command: .JOIN(channels: [IRCChannelName("#lug")!], keys: nil)))

    while(connected) {
        print("> ", terminator: "")
        let rawInput = readLine()!
        var splitInput = rawInput.split(separator: " ")
        let command = splitInput.removeFirst()
        switch command {
        case "PRIVMSG" :
            print(splitInput)
            bot.ircClient.sendMessage(.init(command: .PRIVMSG([IRCMessageRecipient("#lug")!], "HELLO")))
        case "NICK" :
            print(splitInput)
        case "JOIN" :
            if splitInput.isEmpty {
                print("not enough arguments")
                break
            }
            bot.ircClient.sendMessage(.init(command: .JOIN(channels: [IRCChannelName(String(splitInput.removeFirst()))!], keys: nil)))
        case "?" :
            print("help")
        default :
            print("UNKNOWN COMMAND")
        }
//        if rawInput == "EXIT" {
//            connected.toggle()
//            bot.ircClient.close()
//        } else {
//            bot.ircClient.sendMessage(.init(command: .JOIN(channels: [IRCChannelName(rawInput)!], keys: nil)))
//        }
    }
}

dispatchMain()
