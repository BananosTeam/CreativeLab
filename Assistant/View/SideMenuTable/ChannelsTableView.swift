//
//  ChannelsTableView.swift
//  Assistant
//
//  Created by Bananos on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

class ChannelsTableView: UITableView, UITableViewDataSource {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollsToTop = false
    }
    
    func deselectSelectedChannel() {
        if let selectedChannel = indexPathForSelectedRow {
            deselectRowAtIndexPath(selectedChannel, animated: false)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataPersistor.sharedPersistor.channels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dequeueReusableCellWithIdentifier(ChannelTableViewCell.ReuseIdentifier) as! ChannelTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.configureWithChannel(DataPersistor.sharedPersistor.channels[indexPath.row])
        return cell
    }
}
