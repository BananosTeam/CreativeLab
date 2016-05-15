//
//  Parser.swift
//  Assistant
//
//  Created by Bananos on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class Parser {
    
    private static let trello = TrelloInterface()
    
    static func parse(tokens: [Token]) {
        // Something related to the current user
        var board: Board?
        var list: List?
        var card: Card?
        var user: SlackUser?
        
        var isCurrentUser = tokens.contains(.CurrentUser)
        var isTask = tokens.contains(.Task)
        var isBoard = tokens.contains(.TBoard)
        
        var isCreate = tokens.contains(.Create)
        var isDelete = tokens.contains(.Delete)
        var isUpdate = tokens.contains(.Update)
        var isGreeting = tokens.contains(.Greeting)
        var isSpeak = tokens.contains(.Speak)
        
        tokens.forEach {
            switch $0 {
            case .TrelloList(let trelloList): list = trelloList
            case .TrelloBoard(let trelloBoard): board = trelloBoard
            case .TrelloCard(let trelloCard): card = trelloCard
            case .User(let slackUser): user = slackUser
            default: break
            }
        }
        
        if isCurrentUser {
            if let list = list {
                if let board = board {
                    // Fetch specific list of specific board
                    let allLists = trello.currentUserLists.filter() { $0.idBoard == board.id }
                    let chosenList = allLists.filter() { $0.id == list.id }.first
                    let listCards = trello.currentUserCards.filter() { $0.idList == chosenList?.id }
                    print(listCards)
                } else {
                    // Fetch specific list of default board
                    let chosenList = trello.currentUserLists.filter() { $0.id == list.id }.first
                    let allCards = trello.currentUserCards.filter() { $0.idList == chosenList?.id }
                    print(allCards)
                }
            } else if isTask {
                // Fetch all tasks
                let allTask = trello.currentUserCards
                print(allTask)
            }
        } else if let user = user {
            if let list = list {
                guard let trelloMemberId = user.trelloUser?.id else { return }
                let tasks = trello.currentUserCards.filter() { $0.idList == list.id }
                let filteredTasks = tasks.filter() { $0.idMembers?.contains(trelloMemberId) ?? false }
                print(filteredTasks)
            } else if isTask {
                // Fetch all tasks for a specific user
                guard let trelloMemberId = user.trelloUser?.id else { return }
                let filteredTasks = trello.currentUserCards.filter() {
                    $0.idMembers?.contains(trelloMemberId) ?? false
                }
                print(filteredTasks)
            } else if isCreate {
                
            } else if isSpeak {
                SlackClient.currentClient?.messager.sendMessage("Hey \(user.slackName), howdy", channel: user.id)
            }
        } else if isCreate {
            // Create something :D
        }
        
    }
}
