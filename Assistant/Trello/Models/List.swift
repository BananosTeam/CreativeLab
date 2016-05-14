//
//  List.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class List {
    var id: String?
    var name: String?
    var closed: Bool?
    var idBoard: String?
    var subscribed: Bool?
}


final class ListParser {
    
    func listsFromDictionaties(dictionaries: [NSDictionary]) -> [List] {
        return dictionaries.map() { listFromDictionary($0) }
    }
    
    func listFromDictionary(dictionary: NSDictionary) -> List {
        let list = List()
        list.id = dictionary["id"] as? String
        list.name = dictionary["name"] as? String
        list.closed = dictionary["closed"] as? Bool
        list.idBoard = dictionary["idBoard"] as? String
        list.subscribed = dictionary["subscribed"] as? Bool
        
        return list
    }
    
}
