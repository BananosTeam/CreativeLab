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
    
}
