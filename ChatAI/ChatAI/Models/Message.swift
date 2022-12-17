//
//  Message.swift
//  ChatAI
//
//  Created by Cédric Bahirwe on 17/12/2022.
//

import Foundation

struct Message: Identifiable, Codable {

    let id: UUID
    var message: String
    let isSender: Bool

    init(id: UUID = UUID(), _ message: String = "", isSender: Bool = true) {
        self.id = id
        self.message = message
        self.isSender = isSender
    }

    static let examples: [Message] = [
        Message("Hello There"),
        Message("Hi There"),
        Message("How is It?"),
        Message("I'm alright and you?"),
        Message("I'm great my friend"),
    ]
}

