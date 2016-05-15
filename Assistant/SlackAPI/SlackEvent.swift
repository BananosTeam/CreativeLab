//
//  SlackEvent.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

enum SlackEvent {
    case Message(SlackMessage)
    case ChannelJoined(SlackChannel)
    case ChannelDeleted(String)
    case ChannelRename(SlackChannel)
//    case UserTyping(user: String, channel: String)
    case Other
    
    init?(json: [String: AnyObject]) {
        print(json)
        guard let eventType = json["type"] as? String else { return nil }
        switch eventType {
        case "message": self = Message(SlackMessage(json: json))
        case "channel_joined": self = ChannelJoined(SlackChannel(json: json["channel"] as? [String: AnyObject] ?? [:]))
        case "channel_left", "channel_deleted": self = ChannelDeleted(json["channel"] as? String ?? "")
        case "channel_rename": self = ChannelRename(SlackChannel(json: json["channel"] as? [String: AnyObject] ?? [:]))
//        case "user_typing": self = UserTyping(user: json["user"] as? String ?? "", channel: json["channel"] as? String ?? "")
        default: self = Other
        }
    }
}
