//
//  UserTableViewCell.swift
//  Assistant
//
//  Created by Bananos on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let ReuseIdentifier = "UserTableViewCell"
    @IBOutlet weak var usernameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func configureWithUser(user: SlackUser) {
        usernameLabel.textColor = UIColor.darkGrayColor()
        usernameLabel.text = user.slackName
    }
}
