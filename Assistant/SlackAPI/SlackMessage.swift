//
//  SlackMessage.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

struct SlackMessage {
    let channel: String
    let user: String
    let text: String
    let ts: NSDate
    
    init(json: [String: AnyObject]) {
        channel = json["channel"] as? String ?? ""
        user = json["user"] as? String ?? ""
        text = json["text"] as? String ?? ""
        ts = NSDate(timeIntervalSince1970: Double(json["ts"] as? String ?? "") ?? 0)
    }
}