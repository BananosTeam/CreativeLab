//
//  Board.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class Board {
    
    var name: String?
    var description: String?
    var idOrganisation: String?
    var isClosed: Bool?
    var members: [BoardMember]?
    
}

final class BoardParser {
    
    
    func boardsFromDictionaties(dictionaries: [NSDictionary]) -> [Board] {
        return dictionaries.map() { boardFromDictionary($0) }
    }
    
    func boardFromDictionary(dictionary: NSDictionary) -> Board {
        let board = Board()
        board.name = dictionary["name"] as? String
        board.description = dictionary["desc"] as? String
        board.idOrganisation = dictionary["idOrganization"] as? String
        board.isClosed = dictionary["closed"] as? Bool
        if let boardMembers = dictionary["memberships"] as? [NSDictionary] {
            board.members = BoardMemberParser().boardMembersFromDictionaties(boardMembers)
        }
        
        return board
    }
}
