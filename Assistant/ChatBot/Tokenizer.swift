//
//  Tokenizer.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

final class Tokenizer {
    static func tokenize(string: String) -> [Token] {
        return string.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " .,=-'`")).flatMap { Token(rawValue: $0) }
    }
}
