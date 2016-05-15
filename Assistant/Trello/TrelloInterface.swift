//
//  TrelloInterface.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class TrelloInterface {
    
    private let trello = Trello.shared
    private let data = TrelloDataHandler.shared
    private let requester = TrelloRequester()
    
    var currentUserBoards: [Board] {
        return data.boards
    }
    
    var currentUserLists: [List] {
        return data.lists
    }
    
    var currentUserCards: [Card] {
        return data.cards
    }
    
    var currentUserMembers: [Member] {
        return data.members
    }
    
    func handleCallbackUrlWithQueryItems(queryItems: [NSURLQueryItem]?) {
        trello.handleCallbackUrlWithQueryItems(queryItems)
    }
    
    func performAuthorisation() {
        trello.performAuthorisation()
    }
    
    func getCardsForMemberId(memberId: String, callback:([Card]?)->()) {
        requester.getCardsForMemberId(memberId, callback: callback)
    }
    
    func populateSlackUsersWIthTrelloMembers() {
        let slackUsers = DataPersistor.sharedPersistor.users
        let trelloMembers = currentUserMembers
        slackUsers.forEach { (slackUser) in
            trelloMembers.forEach({ (trelloMember) in
                let slackUserName = slackUser.firstName ?? "" + " " + (slackUser.lastName ?? "")
                let slackInvertedUserName = slackUser.lastName ?? "" + " " + (slackUser.firstName ?? "")
                let slackPossibleNames: [String] = [slackUser.name ?? "", slackUser.slackName ?? "",
                                                slackUser.lastName ?? "", slackUser.firstName ?? "",
                                                slackUserName, slackInvertedUserName]
                let trelloUsername = trelloMember.username ?? ""
                let treloFullname = trelloMember.fullName ?? ""
                if slackPossibleNames.contains(trelloUsername) || slackPossibleNames.contains(treloFullname) {
                    slackUser.trelloUser = trelloMember
                }
                
            })
        }
    }
    
}
