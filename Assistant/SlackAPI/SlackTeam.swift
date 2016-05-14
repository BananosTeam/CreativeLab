//
//  SlackTeam.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

struct SlackTeam {
    let id: String
    let name: String
    
    init(json: [String: AnyObject]) {
        id = json["id"] as? String ?? ""
        name = json["name"] as? String ?? ""
    }
}