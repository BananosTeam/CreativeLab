//
//  NSData+Trello.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

extension NSDate {
    
    static func dateFromtrellorDate(trellorDate: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        if let dateString = trellorDate.componentsSeparatedByString("T").first,
            date = formatter.dateFromString(dateString) {
            return date
        }
        return nil
    }
    
}
