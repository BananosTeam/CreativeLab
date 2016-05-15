//
//  BoardMember.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

enum MemberType: String {
    case Normal = "normal"
    case Admin = "admin"
}

final class BoardMember {
    var id: String?
    var memberId: String?
    var memberType: MemberType?
    var orgMemberType: MemberType?
}

final class BoardMemberParser {
    
    func boardMembersFromDictionaties(dictionaries: [NSDictionary]) -> [BoardMember] {
        return dictionaries.map() { boardMembersFromDictionary($0) }
    }
    
    func boardMembersFromDictionary(dictionary: NSDictionary) -> BoardMember {
        let boardMember = BoardMember()
        boardMember.id = dictionary["id"] as? String
        boardMember.memberId = dictionary["idMember"] as? String
        boardMember.memberType = MemberType(rawValue: (dictionary["memberType"] as? String) ?? "")
        boardMember.orgMemberType = MemberType(rawValue: (dictionary["orgMemberType"] as? String) ?? "")
        
        return boardMember
    }
    
}
