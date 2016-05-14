//
//  MessagesTableView.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class MessagesTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    private(set) var messages = [Message]()
    
    func setInitialMessages(messages: [Message]) {
        self.messages = messages
    }
    
    func addMessage(message: Message) {
        messages.append(message)
        updateLastCell()
    }
    
    // MARK: Private methods
    
    private func updateLastCell() {
        let indexPathsToInsert = NSIndexPath(forRow: messages.count - 1, inSection: 0)
        beginUpdates()
        insertRowsAtIndexPaths([indexPathsToInsert], withRowAnimation: rawAnimationForLastMessage)
        endUpdates()
        scrollToRowAtIndexPath(indexPathsToInsert, atScrollPosition: .Bottom, animated: true)
    }
    
    private var rawAnimationForLastMessage: UITableViewRowAnimation {
        guard let lastMessage = messages.last else { return .None }
        switch lastMessage.messageType {
        case .ToMe: return .Left
        case .FromMe: return .Right
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.messageType == .ToMe {
            if let cell = tableView.dequeueReusableCellWithIdentifier(MessageTableViewCell.ToMeReuseIdentifier) as? MessageTableViewCell {
                let messageLabelWidth = message.message.sizeWithFont(UIFont.systemFontOfSize(30)).width + 35
                if cell.frame.width > messageLabelWidth {
                    cell.constraint.constant = messageLabelWidth
                }
                setNeedsLayout()
                layoutIfNeeded()
                return cell
            } else {
                return UITableViewCell(style: .Default, reuseIdentifier: "DefaltCellReuseIdentifier")
            }
        } else {
            if let cell = tableView.dequeueReusableCellWithIdentifier(MessageTableViewCell.FromMeReuseIdentifier) as? MessageTableViewCell {
                let messageLabelWidth = message.message.sizeWithFont(UIFont.systemFontOfSize(30)).width + 35
                if cell.frame.width > messageLabelWidth {
                    cell.constraint.constant = messageLabelWidth
                }
                setNeedsLayout()
                layoutIfNeeded()
                return cell
            } else {
                return UITableViewCell(style: .Default, reuseIdentifier: "DefaltCellReuseIdentifier")
            }
        }
    }
}
