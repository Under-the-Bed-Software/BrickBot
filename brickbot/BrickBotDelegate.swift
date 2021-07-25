//
//  BrickBotDelegate.swift
//  brickbot
//
//  Created by skg on 7/24/21.
//

//import struct Foundation.TimeInterval
//import struct Foundation.Date
import Foundation
import NIO
import IRC

public let defaultNickName = IRCNickName("BrickBot")!

open class BrickBot: IRCClientDelegate {
    
    open class Options : IRCClientOptions {
        
        override public init(port: Int = DefaultIRCPort,
                             host: String = "irc.snoonet.org",
                             securityOptions: IRCClientSecurityOptions = IRCClientSecurityOptions(),
                             password: String? = nil,
                             nickname: IRCNickName = defaultNickName,
                             userInfo: IRCUserInfo? = nil,
                             eventLoopGroup: EventLoopGroup? = nil)
        {
            super.init(port: port, host: host, securityOptions: securityOptions, password: password,
                       nickname: nickname, userInfo: userInfo,
                       eventLoopGroup: eventLoopGroup)
        }
    }
    
    public let options   : Options
    public let ircClient : IRCClient
    public let channels : [IRCChannelName]
    public var botCommands: [String: Command]
    
    public private(set) var nick : IRCNickName
    
    public init(options: Options = Options(), channels: [IRCChannelName] = []) {
        self.options   = options
        self.nick      = options.nickname
        self.ircClient = IRCClient(options: options)
        self.channels = channels
        self.botCommands = [:]
        self.ircClient.delegate = self
    }
    
    open func connect() {
        ircClient.connect()
    }
    
    open func loadCommands() {
        let fm = FileManager.default
        let commandsPath = fm.currentDirectoryPath + "/" + "Commands"        
        do {
            let commandFiles = try fm.contentsOfDirectory(atPath: commandsPath)
            let commandNames = commandFiles.map { String($0.split(separator: ".")[0]) }
            for commandName in commandNames {
                if let potentialCommand = commandName.toMyModuleClass() as? Command.Type {
                    let newCommand = potentialCommand.init()
                    botCommands[newCommand.command] = newCommand
                } else {
                    print("Error loading \(commandName)")
                }
            }
        } catch {
            print(error)
        }
        
        print(botCommands)
    }
    
    // MARK: - IRC message handling
    
    // server messages?
    open func client(_ client: IRCClient, received message: IRCMessage) {
        print("\(Date().timeIntervalSince1970) : \(message.command)")
    }
    
    // normal messages
    open func client(_ client: IRCClient, message: String, from user: IRCUserID, for recipients: [IRCMessageRecipient]) {
        // check first word of message for the command character (, in my case)
        if message[message.index(message.startIndex, offsetBy: 0)] == "," {
            print("command detected")
        }
    }
    
    // MARK: - user is registered here
    
    open func client(_ client        : IRCClient,
                     registered nick : IRCNickName,
                     with   userInfo : IRCUserInfo)
    {
        self.nick = nick
        // Here is where the bot has officially finished registering on the network and can do what it wants
        self.ircClient.sendMessage(.init(command: .JOIN(channels: [IRCChannelName("#danshou")!], keys: nil)))
    }
    
    open func client(_ client: IRCClient, changedNickTo nick: IRCNickName) {
        self.nick = nick
    }
    
    
    open func clientFailedToRegister(_ client: IRCClient) {
        print("failed to register")
    }
    
    
}
