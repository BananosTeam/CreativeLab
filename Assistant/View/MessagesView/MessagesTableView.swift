//
//  MessagesTableView.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class MessagesTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    private let persistor = DataPersistor.sharedPersistor
    
    func reloadLastMessage() {
        updateLastCell()
    }
    
    // MARK: Private methods
    
    private func updateLastCell() {
        let indexPathsToInsert = NSIndexPath(forRow: persistor.messages.count - 1, inSection: 0)
        beginUpdates()
        insertRowsAtIndexPaths([indexPathsToInsert], withRowAnimation: rowAnimationForLastMessage)
        endUpdates()
        scrollToRowAtIndexPath(indexPathsToInsert, atScrollPosition: .Bottom, animated: true)
    }
    
    private var rowAnimationForLastMessage: UITableViewRowAnimation {
        guard let lastMessage = persistor.messages.last else { return .None }
        switch lastMessage.messageType {
        case .ToMe: return .Left
        case .FromMe: return .Right
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persistor.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = persistor.messages[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(MessageTableViewCell.ReuseIdentifier) as! MessageTableViewCell
        cell.configureWithMessage(message)
        return cell
    }
}
