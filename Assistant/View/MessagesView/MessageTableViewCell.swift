//
//  MessageCellViewTableViewCell.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {
    static let ReuseIdentifier = "MessageCellIdentifier"
    static let DefaultReuseIdentifier = "DefaltCellReuseIdentifier"
    @IBOutlet weak var messageLabel: UILabel!
    
    func configureWithMessage(message: Message) {
        messageLabel.text = message.slackMessage.text
        messageLabel.textAlignment = alignmentForMessageType(message.messageType)
        messageLabel.textColor = colorForMessageType(message.messageType)
    }
    
    private func alignmentForMessageType(type: MessageType) -> NSTextAlignment {
        return type == .ToMe ? .Left : .Right
    }
    
    private func colorForMessageType(type: MessageType) -> UIColor {
        return type == .ToMe ?
            UIColor(red: 0 / 256, green: 51 / 256, blue: 153 / 256, alpha: 1) :
            UIColor(red: 0 / 256, green: 204 / 256, blue: 0 / 256, alpha: 1)
    }
}
