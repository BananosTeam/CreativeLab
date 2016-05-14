//
//  String.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

extension String {
    func sizeWithFont(font: UIFont) -> CGSize {
        let attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.blackColor()]
        return (self as NSString).sizeWithAttributes(attributes)
    }
}
