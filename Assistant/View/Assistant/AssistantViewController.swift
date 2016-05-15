//
//  AssistantViewController.swift
//  Assistant
//
//  Created by Bananos on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class AssistantViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, StoryboardInstantiable {
    static let ControllerIdentifier = "AssistantViewController"
    @IBOutlet weak var messagesTableView: MessagesTableView!
    @IBOutlet weak var typeMessageTextView: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var typeMessageViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessagesTableView()
        setupKeyboardNotifications()
        sendMessageButton.enabled = false
        typeMessageTextView.delegate = self
    }
    
    private func setupMessagesTableView() {
        messagesTableView.dataSource = self
        messagesTableView.estimatedRowHeight = 30
        messagesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow),
                                                         name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide),
                                                         name:UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardSizeWillChange),
                                                         name:UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: Actions
    
    @IBAction func sendMessage(sender: AnyObject) {
        guard let messageText = typeMessageTextView.text else { return }
        DataPersistor.sharedPersistor.addBotMessage(BotMessage(message: messageText, messageType: .FromMe))
        updateLastCell()
        
        typeMessageTextView.text = nil
        sendMessageButton.enabled = false
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        UIView.animateWithDuration(0.3) {
            self.typeMessageViewBottomConstraint.constant = keyboardFrame.size.height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3) {
            self.typeMessageViewBottomConstraint.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardSizeWillChange(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        typeMessageViewBottomConstraint.constant = keyboardFrame.size.height
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    // UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text  = textField.text else { return false }
        if (text as NSString).stringByReplacingCharactersInRange(range, withString: string) == "" {
            sendMessageButton.enabled = false
        } else {
            sendMessageButton.enabled = true
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let text = textField.text where text != "" else { return false }
        sendMessage(sendMessageButton)
        return true
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataPersistor.sharedPersistor.botMessages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AssistantMessageTableViewCell.ReuseIdentifier) as! AssistantMessageTableViewCell
        cell.configureWithMessage(DataPersistor.sharedPersistor.botMessages[indexPath.row])
        return cell
    }
    
    func reloadLastMessage() {
        updateLastCell()
    }
    
    // MARK: Private methods
    
    private func updateLastCell() {
        let indexPathsToInsert = NSIndexPath(forItem: DataPersistor.sharedPersistor.botMessages.count - 1, inSection: 0)
        messagesTableView.beginUpdates()
        messagesTableView.insertRowsAtIndexPaths([indexPathsToInsert], withRowAnimation: rowAnimationForLastMessage)
        messagesTableView.endUpdates()
        messagesTableView.scrollToRowAtIndexPath(indexPathsToInsert, atScrollPosition: .Bottom, animated: true)
    }
    
    private var rowAnimationForLastMessage: UITableViewRowAnimation {
        guard let lastMessage = DataPersistor.sharedPersistor.botMessages.last else { return .None }
        switch lastMessage.messageType {
        case .ToMe: return .Left
        case .FromMe: return .Right
        }
    }
}