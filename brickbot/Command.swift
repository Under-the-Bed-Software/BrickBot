//
//  Command.swift
//  brickbot
//
//  Created by skg on 7/25/21.
//

import Foundation

public class Command {
    var command: String = ""
    var description: String = ""
    required init() {}
    func command(input: String) -> String? {nil}
    func register() {}
    
}

extension String {
    func toMyModuleClass() -> AnyClass? {
        struct My {
            static let moduleName = String(reflecting: Command.self).prefix{$0 != "."}
        }
        return NSClassFromString("\(My.moduleName).\(self)")
    }
}
