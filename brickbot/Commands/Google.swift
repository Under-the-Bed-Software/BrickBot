//
//  Google.swift
//  brickbot
//
//  Created by skg on 7/25/21.
//

import Foundation

class Google: Command {
    required init() {
        super.init()
        self.command = "g"
        self.description = "Googles stuff using Bing"
    }
    
    override func command(input: String) -> String? {
        return "asdf"
    }
    
    override func register() {
        print("inside google!")
    }
}
