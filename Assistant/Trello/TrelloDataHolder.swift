//
//  TrelloDataHolder.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class TrelloDataHandler {
    
    static let shared = TrelloDataHandler()
    private init() {}
    
    private let requester = TrelloRequester()
    
    var boards = [Board]()
    var lists = [List]()
    var cards = [Card]()
    var members = [Member]()
    
    func loadData() {
        requester.getBoards {
            guard let userBoards = $0 else { return }
            self.boards = userBoards
            self.boards.forEach() {
                if let boardId = $0.id {
                    self.fillDataForBoardId(boardId)
                }
            }
        }
    }
    
    private func fillDataForBoardId(id: String) {
        getListsForBoardId(id)
        getCardsForBordId(id)
        getMembersForBoardId(id)
    }
    
    private func getListsForBoardId(id: String) {
        requester.getLists(id, callback: { (list) in
            if let newItems = list {
                newItems.forEach() {
                    let existiogMembersIds = self.members.flatMap() { $0.id }
                    if let id = $0.id where !existiogMembersIds.contains(id) {
                        self.lists += newItems
                    }
                }
            }
            if let listId = self.lists.first?.id {
                CardCRUD().createCard(listId)
            }
        })
    }
    
    private func getCardsForBordId(id: String) {
        requester.getCards(id, callback: { (cards) in
            if let newItems = cards {
                newItems.forEach() {
                    let existiogMembersIds = self.members.flatMap() { $0.id }
                    if let id = $0.id where !existiogMembersIds.contains(id) {
                        self.cards += newItems
                    }
                }
            }
            if let cardId = self.cards.first?.id {
                CardCRUD().deleteCard(cardId)
            }
        })
    }
    
    private func getMembersForBoardId(id: String) {
        requester.getMembers(id, callback: { (members) in
            if let newItems = members {
                newItems.forEach() {
                    let existiogMembersIds = self.members.flatMap() { $0.id }
                    if let id = $0.id where !existiogMembersIds.contains(id) {
                        self.members += newItems
                    }
                }
            }
            TrelloInterface().populateSlackUsersWIthTrelloMembers()
        })
    }
    
}
