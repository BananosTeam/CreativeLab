//
//  SlackUser.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

struct SlackUser {
    let firstName: String?
    let lastName: String?
    let name: String?
    let presence: Bool?
    let slackName: String
    let id: String
    let imageURL: String
    
    init?(json: [String: AnyObject]) {
        guard let id = json["id"] as? String,
            slackName = json["name"] as? String,
            profile = json["profile"] as? [String: String],
            image = profile["image_48"] else {
                return nil
        }
        self.id = id
        self.slackName = slackName
        firstName = profile["first_name"]
        lastName = profile["last_name"]
        name = profile["real_name"]
        imageURL = image
        presence = false
    }
}