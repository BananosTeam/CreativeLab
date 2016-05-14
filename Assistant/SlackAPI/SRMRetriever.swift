//
//  SRMRetriever.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

protocol SRMRetriever {
    func setUsers(callback: [SlackUser])
    func setChannels(callback: [SlackChannel])
    func setCurrentUser(callback: SlackUser?)
    func setTeam(callback: SlackTeam)
}
