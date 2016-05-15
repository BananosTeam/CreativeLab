//
//  ChannelTableViewCell.swift
//  Assistant
//
//  Created by Bananos on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    static let ReuseIdentifier = "ChannelTableViewCell"
    @IBOutlet weak var channelNameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func configureWithChannel(channel: SlackChannel) {
        channelNameLabel.textColor = UIColor.darkGrayColor()
        channelNameLabel.text = channel.name
    }
}
