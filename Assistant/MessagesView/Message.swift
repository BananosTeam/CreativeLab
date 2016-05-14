//
//  Message.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

enum MessageType {
    case FromMe
    case ToMe
}

struct Message {
    let message: String
    let messageType: MessageType
}
