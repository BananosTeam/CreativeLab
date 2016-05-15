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
    
    func sideMenuWillOpen() {
        if channelsTableView.indexPathForSelectedRow == nil && usersTableView.indexPathForSelectedRow == nil {
            channelsTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .None)
        }
        guard let messagesVC = (sideMenuController() as? NavigationController)?.childViewControllers.first
            as? MessagesViewController else { return }
        messagesVC.typeMessageTextView.resignFirstResponder()
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
        ((sideMenuController() as? NavigationController)?.childViewControllers.first as? MessagesViewController)?.messagesTableView.reloadData()
        sideMenuController()?.sideMenu?.hideSideMenu()
        
    }
    
    private func handleUserSelectionAtIndex(index: Int) {
        guard let messagesVC = (sideMenuController() as? NavigationController)?.childViewControllers.first
            as? MessagesViewController else { return }
        messagesVC.currentOpenChannel = nil
        messagesVC.currentOpenChannelWithUser = DataPersistor.sharedPersistor.users[index]
    }
    
    private func handleChannelSelectionAtIndex(index: Int) {
        guard let messagesVC = (sideMenuController() as? NavigationController)?.childViewControllers.first
            as? MessagesViewController else { return }
        messagesVC.currentOpenChannel = DataPersistor.sharedPersistor.channels[index]
        messagesVC.currentOpenChannelWithUser = nil
    }
    
    // MARK: SRMDelegate
    
    func eventReceived(event: SlackEvent) {
        if case .Message(let message) = event {
            DataPersistor.sharedPersistor.addMessage(Message(slackMessage: message, messageType: .ToMe))
            if let messagesVC = (sideMenuController() as? NavigationController)?.childViewControllers.first
                as? MessagesViewController {
                messagesVC.reloadLastMessage()
            }
        }
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
