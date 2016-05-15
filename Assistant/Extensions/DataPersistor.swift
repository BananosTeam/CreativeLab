//
//  DataPersistor.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class DataPersistor {
    static var sharedPersistor = DataPersistor()
    
    private(set) var currentUser: SlackUser?
    private(set) var users = [SlackUser]()
    private(set) var channels = [SlackChannel]()
    private(set) var messages = [Message]()
    private(set) var team: SlackTeam?
    
    private init() {}
    
    func addUsers(users: [SlackUser]) {
        self.users.appendContentsOf(users)
    }

    func addChannels(channels: [SlackChannel]) {
        self.channels.appendContentsOf(channels)
    }
    
    func setCurrentUser(user: SlackUser) {
        self.currentUser = user
    }
    
    func setTeam(team: SlackTeam) {
        self.team = team
    }
    
    func addMessages(messages: [Message]) {
        self.messages.appendContentsOf(messages)
    }
    
    func addMessage(message: Message) {
        self.messages.append(message)
    }
}
