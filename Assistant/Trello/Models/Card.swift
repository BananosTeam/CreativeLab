//
//  Card.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class Card {
    var id: String?
    var idShort: String?
    var name: String?
    var isClosed: Bool?
    var idList: String?
    var dueDate: NSDate?
    var dateLastActivity: NSDate?
    var description: String?
    var idBoard: String?
    var idMembers: [String]?
    var subscribed: Bool?
}

final class CardParser {
    
    func cardsFromDictionaties(dictionaries: [NSDictionary]) -> [Card] {
        return dictionaries.map() { cardFromDictionary($0) }
    }
    
    func cardFromDictionary(dictionary: NSDictionary) -> Card {
        let card = Card()
        card.id = dictionary["id"] as? String
        card.idShort = dictionary["idShort"] as? String
        card.name = dictionary["name"] as? String
        card.isClosed = dictionary["closed"] as? Bool
        card.idList = dictionary["idList"] as? String
        card.description = dictionary["desc"] as? String
        card.idBoard = dictionary["idBoard"] as? String
        card.subscribed = dictionary["subscribed"] as? Bool
        card.idMembers = dictionary["idMembers"] as? [String]
        if let stringDate = dictionary["due"] as? String,
            lastActivity = NSDate.dateFromtrellorDate(stringDate) {
            card.dueDate = lastActivity
        }
        if let stringDate = dictionary["dateLastActivity"] as? String,
            lastActivity = NSDate.dateFromtrellorDate(stringDate) {
            card.dateLastActivity = lastActivity
        }
        
        return card
    }
    
}
