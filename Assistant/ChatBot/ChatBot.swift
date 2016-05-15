//
//  ChatBot.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

class ChatBot {
    
    var slackUsers: [SlackUser]
    var boards: [Board]
    var lists: [List]
    var cards: [Card]
    
    init(slackUsers: [SlackUser] = [], boards: [Board] = [], lists: [List] = [], cards: [Card] = []) {
        self.slackUsers = slackUsers
        self.boards = boards
        self.lists = lists
        self.cards = cards
    }
    
    func parseString(string: String) {
        let userTokensTuple = self.userTokens(string)
        let userTokens = userTokensTuple.tokens
        let noSlackUsersString = userTokensTuple.newString
        
        var tokens = userTokens + Tokenizer.tokenize(noSlackUsersString)
        
        let boardTokenTuple = boardToken(noSlackUsersString)
        if let boardToken = boardTokenTuple.token { tokens += [boardToken] }
        let noBoardString = boardTokenTuple.newString
        
        let listTokenTuple = listToken(noBoardString)
        if let listToken = listTokenTuple.token { tokens += [listToken] }
        let noListString = listTokenTuple.newString
        
        let cardTokenTuple = cardToken(noListString)
        if let cardToken = cardTokenTuple.token { tokens += [cardToken] }
        let finalString = cardTokenTuple.newString
        
        tokens += Tokenizer.tokenize(finalString)
        
        Parser.parse(tokens)
    }
    
    private func userTokens(string: String) -> (tokens: [Token], newString: String) {
        return slackUsers.map { ($0, $0.nameCombinations()) }.reduce(([Token](), string)) { tuple, slackUser in
            guard let regex = try? NSRegularExpression(pattern: "(\(slackUser.1.joinWithSeparator("|")))", options: []) else {
                print("Invalid regex my friend!")
                return tuple
            }
            guard let userMatch = regex.firstMatchInString(string, options: [], range: NSMakeRange(0, string.characters.count)) else {
                print("No user match")
                return tuple
            }
            if userMatch.range.location == 0 && userMatch.range.length == 0 { return tuple }
            let finalString = (tuple.1 as NSString).stringByReplacingCharactersInRange(userMatch.range, withString: "")
            print("Found user \(slackUser.0.slackName)")
            return (tuple.0 + [.User(slackUser.0)], finalString)
        }
    }
    
    private func boardToken(string: String) -> (token: Token?, newString: String) {
        return boards.flatMap {
            guard let name = $0.name,
                regex = try? NSRegularExpression(pattern: "(\(name))", options: []),
                userMatch = regex.firstMatchInString(name, options: [], range: NSMakeRange(0, name.characters.count)) else {
                print("Invalid regex my friend!")
                return nil
            }
            let nsString = string as NSString
            return (.TrelloBoard($0), nsString.stringByReplacingCharactersInRange(userMatch.range, withString: ""))
        }.first ?? (nil, string)
    }
    
    private func listToken(string: String) -> (token: Token?, newString: String) {
        return lists.flatMap {
            guard let name = $0.name,
                regex = try? NSRegularExpression(pattern: "(\(name))", options: []),
                userMatch = regex.firstMatchInString(name, options: [], range: NSMakeRange(0, name.characters.count)) else {
                    print("Invalid regex my friend!")
                    return nil
            }
            let nsString = string as NSString
            return (.TrelloList($0), nsString.stringByReplacingCharactersInRange(userMatch.range, withString: ""))
            }.first ?? (nil, string)
    }
    
    private func cardToken(string: String) -> (token: Token?, newString: String) {
        return cards.flatMap {
            guard let name = $0.name,
                regex = try? NSRegularExpression(pattern: "(\(name))", options: []),
                userMatch = regex.firstMatchInString(name, options: [], range: NSMakeRange(0, name.characters.count)) else {
                    print("Invalid regex my friend!")
                    return nil
            }
            let nsString = string as NSString
            return (.TrelloCard($0), nsString.stringByReplacingCharactersInRange(userMatch.range, withString: ""))
            }.first ?? (nil, string)
    }
}
