//
//  Token.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

enum Token: Equatable {
    case Task
    case TBoard
    
    case Date(NSDate)
    case CurrentUser
    case Greeting
    case Gratitude
    case Direction
    case Speak
    
    case Trello
    case TrelloBoard(Board)
    case TrelloCard(Card)
    case TrelloList(List)
    
    case User(SlackUser)
    
    init?(rawValue: String) {
        switch rawValue.lowercaseString {
        case let word where word.hasPrefix("task") || word.hasPrefix("card"): self = Task
        case let word where word.hasPrefix("today"): self = Date(NSDate())
        case let word where word.hasPrefix("tomorrow"): self = Date(NSDate().dateByAddingTimeInterval(24 * 3600))
        case let word where word.hasPrefix("thank"): self = Gratitude
        case let word where word.hasPrefix("board"): self = TBoard
        case "trelo", "trello": self = Trello
        case "tell", "say", "speak", "answer", "inform", "instruct", "explain", "reveal", "ask": self = Speak
        case "for", "to", "of", "his", "her": self = Direction
        case "my", "mine", "I": self = CurrentUser
        case "hi", "hey", "hello", "howdy", "hola", "salut", "noroc", "darow", "morning", "morn": self = Greeting
        default: return nil
        }
    }
}

func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.Task, .Task),
         (.TBoard, .TBoard),
         (.Greeting, .Greeting),
         (.Gratitude, .Gratitude),
         (.Direction, .Direction),
         (.Speak, .Speak),
         (.Trello, .Trello),
         (.TrelloBoard(_), .TrelloBoard(_)),
         (.TrelloCard(_), .TrelloCard(_)),
         (.TrelloList(_), .TrelloList(_)),
         (.User(_), .User(_)),
         (.Date(_), .Date(_)),
         (.CurrentUser, .CurrentUser): return true
    default: return false
    }
}

