//
//  SlackUser.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class SlackUser {
    let firstName: String?
    let lastName: String?
    let name: String?
    let presence: Bool?
    let slackName: String
    let id: String
    let imageURL: String
    var trelloUser: Member?
    
    init?(json: [String: AnyObject]) {
        guard let id = json["id"] as? String,
            slackName = json["name"] as? String,
            profile = json["profile"] as? [String: AnyObject],
            image = profile["image_48"] as? String else {
                return nil
        }
        self.id = id
        self.slackName = slackName
        firstName = profile["first_name"] as? String
        lastName = profile["last_name"] as? String
        name = profile["real_name"] as? String
        imageURL = image
        presence = false
    }
    
    func nameCombinations() -> [String] {
        return [self.slackName, self.name, "\(firstName) \(lastName)", "\(lastName) \(firstName)"].flatMap { $0 }
    }
}