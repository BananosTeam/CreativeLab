//
//  MessageCellViewTableViewCell.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {
    static let ToMeReuseIdentifier = "ToMeMessageCellIdentifier"
    static let FromMeReuseIdentifier = "FromMeMessageCellIdentifier"
    @IBOutlet weak var messageContentView: UIView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
}
