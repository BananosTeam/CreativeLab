//
//  SideMenuTableViewController.swift
//  Assistant
//
//  Created by Bananos on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class SideMenuViewController: UIViewController, StoryboardInstantiable, ENSideMenuDelegate,
                                    UITableViewDelegate, SRMDelegate, SRMRetriever {
    static let ControllerIdentifier = "SideMenuViewController"
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var channelsTableView: ChannelsTableView!
    @IBOutlet weak var usersTableView: UsersTableView!
    @IBOutlet weak var fetchingUsersActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fetchingChannelsActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelsTableView.delegate = self
        usersTableView.delegate = self
        channelsTableView.dataSource = channelsTableView
        usersTableView.dataSource = usersTableView
        SlackClient.currentClient?.delegate = self
        SlackClient.currentClient?.dataRetriever = self
    }
    
    // MARK: ENSideMenuDelegate
    
    func sideMenuShouldOpenSideMenu () -> Bool {
        return true
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView === usersTableView {
            channelsTableView.deselectSelectedChannel()
            handleUserSelectionAtIndex(indexPath.row)
        } else if tableView === channelsTableView {
            usersTableView.deselectSelectedUser()
            handleChannelSelectionAtIndex(indexPath.row)
        }
    }
    
    private func handleUserSelectionAtIndex(index: Int) {
        debugPrint("User selected at index \(index)")
    }
    
    private func handleChannelSelectionAtIndex(index: Int) {
        guard let messagesVC = (sideMenuController() as? NavigationController)?.childViewControllers.first
            as? MessagesViewController else { return }
        messagesVC.currentOpenChannel = DataPersistor.sharedPersistor.channels[index]
    }
    
    // MARK: SRMDelegate
    
    func eventReceived(event: SlackEvent) {
        debugPrint(event)
    }
    
    // MARK: SRMRetriever
    
    func setUsers(callback: [SlackUser]) {
        DataPersistor.sharedPersistor.addUsers(callback)
        usersTableView.reloadData()
        let trello = TrelloInterface()
        trello.populateSlackUsersWIthTrelloMembers()
        fetchingUsersActivityIndicator.stopAnimating()
    }
    
    func setChannels(callback: [SlackChannel]) {
        DataPersistor.sharedPersistor.addChannels(callback)
        channelsTableView.reloadData()
        fetchingChannelsActivityIndicator.stopAnimating()
    }
    
    func setCurrentUser(callback: SlackUser?) {
        if let currentUser = callback {
            DataPersistor.sharedPersistor.setCurrentUser(currentUser)
            setCurrentUserName()
        }
    }
    
    func setTeam(callback: SlackTeam) {
        DataPersistor.sharedPersistor.setTeam(callback)
        setCurrentTeamName()
    }
    
    private func setCurrentUserName() {
        guard let currentUser = DataPersistor.sharedPersistor.currentUser else { return }
        usernameLabel.text = currentUser.slackName
    }
    
    private func setCurrentTeamName() {
        guard let currentTeam = DataPersistor.sharedPersistor.team else { return }
        teamNameLabel.text = currentTeam.name
    }
}
