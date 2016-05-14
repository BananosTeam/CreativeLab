//
//  Member.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class Member {
    var id: String?
    var fullName: String?
    var username: String?
}

final class MemberParser {
    
    func membersFromDictionaties(dictionaries: [NSDictionary]) -> [Member] {
        return dictionaries.map() { memberFromDictionary($0) }
    }
    
    func memberFromDictionary(dictionary: NSDictionary) -> Member {
        let member = Member()
        member.id = dictionary["id"] as? String
        member.username = dictionary["username"] as? String
        member.fullName = dictionary["fullName"] as? String
        
        return member
    }
    
}
