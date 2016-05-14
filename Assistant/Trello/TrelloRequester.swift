//
//  TrelloRequester.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation
import Alamofire

private let TrelloURL = "https://api.trello.com/1"

final class TrelloRequester {
    
    func getMembers(boardId: String, callback:([Member]?)->()) {
        let module = "/boards/\(boardId)/members"
        getRequest(module) {
            if let responseData = $0?.result.value as? NSArray {
                let cardsArray = responseData.flatMap() { $0 as? NSDictionary }
                let cards = MemberParser().membersFromDictionaties(cardsArray)
                callback(cards)
            } else {
                callback(nil)
            }
        }
    }
    
    func getCards(boardId: String, callback:([Card]?)->()) {
        let module = "/boards/\(boardId)/cards"
        getRequest(module) {
            if let responseData = $0?.result.value as? NSArray {
                let cardsArray = responseData.flatMap() { $0 as? NSDictionary }
                let cards = CardParser().cardsFromDictionaties(cardsArray)
                callback(cards)
            } else {
                callback(nil)
            }
        }
    }
    
    func getBoards(callback:([Board]?)->()) {
        let module = "/member/me/boards"
        getRequest(module) {
            if let responseData = $0?.result.value as? NSArray {
                let boardsArray = responseData.flatMap() { $0 as? NSDictionary }
                let boards = BoardParser().boardsFromDictionaties(boardsArray)
                callback(boards)
            } else {
                callback(nil)
            }
        }
    }
    
    func getLists(boardId: String, callback:([List]?)->()) {
        let module = "/boards/\(boardId)/lists"
        getRequest(module) {
            if let responseData = $0?.result.value as? NSArray {
                let listsArray = responseData.flatMap() { $0 as? NSDictionary }
                let lists = ListParser().listsFromDictionaties(listsArray)
                callback(lists)
            } else {
                callback(nil)
            }
        }
    }
    
    private func getRequest(module: String, callback:(response: Response<AnyObject, NSError>?) -> Void) {
        guard let url = NSURL(string: TrelloURL + module) else {
                callback(response: nil)
                return
        }
        let request = Alamofire.request(.GET,
                                        url,
                                        parameters: defaultParams,
                                        encoding: .JSON,
                                        headers: trelloHeaders)
        request.responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            callback(response: response)
        }
    }
    
    private var trelloHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    private var defaultParams: [String: String] {
        guard let token = Trello.shared.getToken() else {
            return ["key": TrelloAplicationKey]
        }
        return ["key": TrelloAplicationKey,
                "token": token ]
    }
    
}