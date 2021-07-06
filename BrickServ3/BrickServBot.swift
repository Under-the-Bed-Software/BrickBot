//
//  BrickServBot.swift
//  BrickServ3
//
//  Created by skg on 7/4/21.
//

import struct Foundation.TimeInterval
import struct Foundation.Date
import NIO
import IRC

public let defaultNickName = IRCNickName("BrickBot")!

open class BrickServBot: IRCClientDelegate {
    
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
    
    open class Session {
        
        weak var bot: BrickServBot?
        let user: IRCNickName
        
        init(user: IRCNickName, bot: BrickServBot) {
            self.user = user
            self.bot = bot
        }
        
        open func sayHello() {
            guard let bot = bot else { return }
            bot.ircClient.sendMessage("Hello", to: .nickname(user))
        }
        
        open func replyTo(_ statement: String) {
            guard let bot = bot else { return }
            bot.ircClient.sendMessage("Bricks", to: .nickname(self.user))
        }
        
    }
    
    public let options   : Options
    public let ircClient : IRCClient
    public let channels : [IRCChannelName]
    
    public private(set) var nick : IRCNickName
    var sessions = [ IRCNickName : Session ]()
    
    public init(options: Options = Options(), channels: [IRCChannelName] = []) {
        self.options   = options
        self.nick      = options.nickname
        self.ircClient = IRCClient(options: options)
        self.channels = channels
        self.ircClient.delegate = self
    }
    
    open func connect() {
        ircClient.connect()
    }
    
    // MARK: - IRC message handling
    
    open func client(_ client: IRCClient, received message: IRCMessage) {
        print("\(Date().timeIntervalSince1970) : \(message.command)")
    }
    
    open func client(_ client: IRCClient, message: String, from user: IRCUserID, for recipients: [IRCMessageRecipient]) {
        print("\(user) : \(message)")
    }
    
    // MARK: - user is registered here
    
    open func client(_ client        : IRCClient,
                     registered nick : IRCNickName,
                     with   userInfo : IRCUserInfo)
    {
        self.nick = nick
        self.ircClient.sendMessage(.init(command: .JOIN(channels: [IRCChannelName("#danshou")!], keys: nil)))
//        print("bot is now registered as \(nick) with userInfo \(userInfo)")
    }
    
    open func client(_ client: IRCClient, changedNickTo nick: IRCNickName) {
        self.nick = nick
    }
    
    
    open func clientFailedToRegister(_ client: IRCClient) {
        print("failed to register")
    }
}
