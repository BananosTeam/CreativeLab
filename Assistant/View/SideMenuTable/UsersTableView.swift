//
//  UsersTableView.swift
//  Assistant
//
//  Created by Bananos on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

class UsersTableView: UITableView, UITableViewDataSource {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollsToTop = false
    }
    
    func deselectSelectedUser() {
        if let selectedUser = indexPathForSelectedRow {
            deselectRowAtIndexPath(selectedUser, animated: false)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataPersistor.sharedPersistor.users.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dequeueReusableCellWithIdentifier(UserTableViewCell.ReuseIdentifier) as! UserTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.configureWithUser(DataPersistor.sharedPersistor.users[indexPath.row])
        return cell
    }
}
